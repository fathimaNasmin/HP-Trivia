//
//  GameViewModel.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/10/25.
//

import Foundation

@MainActor
class GameViewModel: ObservableObject {
	private var allQuestions: [Question] = []
	// store asked question's id's
	private var answeredQuestions: [Int] = []
	
	var filteredQuestions: [Question] = []
	var currentQuestions = Constants.previewQuestion
	var answers: [String] = []
	
	var answer: String {
		currentQuestions.answers.first(where: { $0.value == true })!.key
	}
	
	init() {
		decodeQuestion()
	}
	
	func filterQuestions(to books: [Int]) {
		filteredQuestions = allQuestions.filter { books.contains($0.book) }
	}
	
	func newQuestion() {
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
		currentQuestions = potentialQuestion
		
		for answer in currentQuestions.answers.keys {
			answers.append(answer)
		}
		
		answers.shuffle()
	}
	
	func correct() {
		answeredQuestions.append(currentQuestions.id)
		
		// TODO: update the score
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
