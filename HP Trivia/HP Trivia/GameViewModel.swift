//
//  GameViewModel.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/10/25.
//

import Foundation
import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
	@Published var gameScore = 0
	@Published var questionScore = 5
	@Published var recentScores = [0, 0, 0]
	
	private var allQuestions: [Question] = []
	// store asked question's id's
	private var answeredQuestions: [Int] = []
	private let savePath = FileManager.documentDirectory.appending(path: "SavedScores")
	
	var filteredQuestions: [Question] = []
	var currentQuestion = Constants.previewQuestion
	var answers: [String] = []
	
	var correctAnswer: String {
		currentQuestion.answers.first(where: { $0.value == true })!.key
	}
	
	init() {
		decodeQuestion()
	}
	
	func filterQuestions(to books: [Int]) {
		filteredQuestions = allQuestions.filter { books.contains($0.book) }
	}
	
	func startGame(){
		gameScore = 0
		questionScore = 5
		answeredQuestions = []
	}
	
	func newQuestion() {
		answers = []
		
		if filteredQuestions.isEmpty {
			return
		}
		
		if answeredQuestions.count == filteredQuestions.count {
			answeredQuestions = []
		}
		
		var potentialQuestion = filteredQuestions.randomElement()!
		while answeredQuestions.contains(potentialQuestion.id) {
			potentialQuestion = filteredQuestions.randomElement()!
		}
		currentQuestion = potentialQuestion
		
		for answer in currentQuestion.answers.keys {
			answers.append(answer)
		}
		
		answers.shuffle()
		
		questionScore = 5
	}
	
	func endGame() {
		recentScores[2] = recentScores[1]
		recentScores[1] = recentScores[0]
		recentScores[0] = gameScore
		
		answeredQuestions = []
		
		saveScores()
	}
	
	private func saveScores() {
		do {
			let data = try JSONEncoder().encode(recentScores)
			try data.write(to: savePath)
		}catch{
			print("Unable to save the data: \(error)")
		}
	}
	
	func loadScores() {
		do {
			let data = try Data(contentsOf: savePath)
			recentScores = try JSONDecoder().decode([Int].self, from: data)
		} catch {
			recentScores = [0, 0, 0]
		}
	}
	
	func correct() {
		answeredQuestions.append(currentQuestion.id)
		withAnimation {
			gameScore += questionScore
		}
	}
	
	private func decodeQuestion() {
		if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
			do {
				let data = try Data(contentsOf: url)
				let decoder = JSONDecoder()
				allQuestions = try decoder.decode([Question].self, from: data)
				filteredQuestions = allQuestions
			}catch {
				print("Error Decoding JSON Data: \(error)")
			}
		}
	}
}
