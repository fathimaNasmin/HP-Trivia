//
//  GamePlayView.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/7/25.
//

import SwiftUI

struct GamePlayView: View {
	@State private var animateViewIn = false
	@State private var tappedCorrectAnswer = false
	
    var body: some View {
		GeometryReader { geo in
			ZStack {
				Image("hogwarts")
					.resizable()
					.frame(width: geo.size.width * 3, height: geo.size.height * 1.03)
					.overlay(Rectangle().foregroundColor(.black.opacity(0.8)))
				
				// MARK: Controls
				VStack {
					HStack {
						Button("End Game"){
							// TODO: End game
						}
						.font(.title3)
						.foregroundColor(.white)
						.padding(10)
						.background(.red.opacity(0.6))
						.cornerRadius(10)
						
						Spacer()
						
						Text("Score: 20")
							.font(.title3)
					}
					.padding([.leading, .trailing], 20)
					.padding(.vertical, 60)
					
					// MARK: Question
					VStack {
						if animateViewIn {
							Text("Who is Harry Potter?")
								.font(.custom(Constants.hpFont, size: 50))
								.padding()
								.multilineTextAlignment(.center)
								.transition(.scale)
						}
					}
					.animation(.easeInOut(duration: 2), value: animateViewIn)
					
					Spacer()
					
					// MARK: Hints
					HStack{
						VStack {
							if animateViewIn {
								Image(systemName: "questionmark.app.fill")
									.resizable()
									.scaledToFit()
									.frame(width: 100)
									.foregroundColor(.cyan)
									.rotationEffect(.degrees(-15))
									.transition(.offset(x: -geo.size.width / 2))
							}
						}
						.animation(.easeOut(duration: 1.5).delay(2), value: animateViewIn)
						
						Spacer()
						
						VStack {
							if animateViewIn {
								Image(systemName: "book.closed")
									.resizable()
									.scaledToFit()
									.frame(width: 50)
									.foregroundColor(.black)
									.frame(width: 100, height: 100)
									.background(.cyan)
									.cornerRadius(20)
									.rotationEffect(.degrees(15))
									.transition(.offset(x: geo.size.width / 2))
								
							}
						}
						.animation(.easeInOut(duration: 1.5).delay(2), value: animateViewIn)
					}
					.padding([.leading, .trailing], 20)
					.padding(.vertical, 40)

					// MARK: Answers
					LazyVGrid(columns: [GridItem(), GridItem()]) {
						ForEach(1..<5){ i in
							VStack {
								if animateViewIn {
									Text("Answer \(i)")
										.minimumScaleFactor(0.5)
										.multilineTextAlignment(.center)
										.padding(10)
										.frame(width: geo.size.width / 2.15, height: 80)
										.background(.green.opacity(0.5))
										.cornerRadius(25)
										.transition(.scale)
								}
									
							}
							.animation(.easeOut(duration: 1).delay(1.5), value: animateViewIn)
								
						}
					}
					
					Spacer()
					
					
				}
				.frame(width: geo.size.width, height: geo.size.height)
				.foregroundColor(.white)
				
				
				// MARK: Celebration
				VStack {
					Spacer()
					
					VStack {
						if tappedCorrectAnswer {
							Text("10")
								.font(.largeTitle)
								.padding(.top, 30)
								.transition(.offset(y: -geo.size.height/4))
						}
					}
					.animation(.easeInOut(duration: 1).delay(2), value: tappedCorrectAnswer)

					
					Spacer()
					
					VStack {
						if tappedCorrectAnswer {
							Text("Brilliant!")
								.font(.custom(Constants.hpFont, size: 100))
								.transition(.scale.combined(with: .offset(y: -geo.size.height/2)))
						}
					}
					.animation(.easeInOut(duration: 1).delay(1), value: tappedCorrectAnswer)
					
					Spacer()
					
					Text("Answer 1")
						.minimumScaleFactor(0.5)
						.multilineTextAlignment(.center)
						.padding(10)
						.frame(width: geo.size.width / 2.15, height: 80)
						.background(.green.opacity(0.5))
						.cornerRadius(25)
						.scaleEffect(2)
					
					Spacer()
					
					VStack {
						if tappedCorrectAnswer {
							Button("Next Level >"){
								// TODO: Reset the level for next question
							}
							.buttonStyle(.borderedProminent)
							.font(.largeTitle)
							.tint(.blue.opacity(0.7))
							.transition(.offset(y: geo.size.height/2))
						}
					}
					.animation(.easeInOut(duration: 2).delay(2.3), value: tappedCorrectAnswer)
					
					Spacer()
				}
				.foregroundColor(.white)
			}
			.frame(width: geo.size.width, height: geo.size.height)
		}
		.ignoresSafeArea()
		.onAppear {
//			animateViewIn = true
			tappedCorrectAnswer = true
		}
    }
}

#Preview {
    GamePlayView()
}
