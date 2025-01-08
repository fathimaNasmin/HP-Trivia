//
//  InstructionView.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/6/25.
//

import SwiftUI

struct InstructionView: View {
	
	@Environment(\.dismiss) private var dismiss
	
    var body: some View {
		ZStack {
			InstructionBackground()
			
			VStack {
				Image("appiconwithradius")
					.resizable()
					.scaledToFit()
					.frame(width: 200)
					.padding()
				
				ScrollView {
					Text("How to Play")
						.font(.largeTitle)
					
					VStack(alignment: .leading) {
						Text("Welcome to HP Trivia! In this game, you will be asked random questions from the HP books and you must guess the right answer or you will lose points!😱")
							.padding([.horizontal, .bottom])
						
						Text("Each question is worth 5 points, but if you guess a wrong answer, you lose 1 point.")
							.padding([.horizontal, .bottom])
						
						Text("If you are struggling with a question, there is an option to reveal a hint or reveal the book that answers the question. But beware! Using these also minuses 1 point each.")
							.padding([.horizontal, .bottom])
						
						Text("When you select the correct answer, you will be awarded all the points left for that question and they will be added to your total score.")
							.padding([.horizontal, .bottom])
					}

					VStack {
						Text("Good Luck!")
							.font(.title)
					}
				}
				.foregroundColor(.black)
				
				Button("Done"){
					dismiss()
				}
				.doneButton()
			}
		}
    }
}

#Preview {
    InstructionView()
}
