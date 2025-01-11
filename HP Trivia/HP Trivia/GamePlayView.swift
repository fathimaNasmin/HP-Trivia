//
//  GamePlayView.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/7/25.
//

import SwiftUI
import AVKit

struct GamePlayView: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject private var game: GameViewModel
	
	@Namespace private var namespace // to connect with view eachother.
	@State private var musicPlayer: AVAudioPlayer!
	@State private var sfxPlayer: AVAudioPlayer!
	@State private var animateViewIn = false
	@State private var tappedCorrectAnswer = false
	@State private var hintWiggle = false
	@State private var scaleNextButton = false
	@State private var movePointsToScores = false
	@State private var revealHint = false
	@State private var revealBook = false
	@State private var tappedWrongAnswers: [Int] = []
	
	
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
							game.endGame()
							dismiss()
						}
						.font(.title3)
						.foregroundColor(.white)
						.padding(10)
						.background(.red.opacity(0.6))
						.cornerRadius(10)
						
						Spacer()
						
						Text("Score: \(game.gameScore)")
							.font(.title3)
					}
					.padding([.leading, .trailing], 20)
					.padding(.vertical, 60)
					
					// MARK: Question
					VStack {
						if animateViewIn {
							Text(game.currentQuestion.question)
								.font(.custom(Constants.hpFont, size: 50))
								.padding()
								.multilineTextAlignment(.center)
								.transition(.scale)
								.opacity(tappedCorrectAnswer ? 0.1 : 1)
						}
					}
					.animation(.easeInOut(duration: animateViewIn ? 2 : 0), value: animateViewIn)
					
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
									.rotationEffect(.degrees(hintWiggle ? -13 : -17))
									.transition(.offset(x: -geo.size.width / 2))
									.onAppear {
										withAnimation(.easeInOut(duration: 0.1).repeatCount(9)
											.delay(5).repeatForever()) {
												hintWiggle = true
											}
									}
									.onTapGesture {
										withAnimation(.easeOut(duration: animateViewIn ? 1 : 0)) {
											revealHint = true
										}
										playFlipSound()
										game.questionScore -= 1
									}
									.rotation3DEffect(.degrees(revealHint ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
									.scaleEffect(revealHint ? 5 : 1)
									.opacity(revealHint ? 0 : 1)
									.offset(x: revealHint ? geo.size.width / 2 : 0)
									.overlay {
										Text(game.currentQuestion.hint)
											.minimumScaleFactor(0.5)
											.multilineTextAlignment(.center)
											.opacity(revealHint ? 1 : 0)
											.scaleEffect(revealHint ? 1.2 : 0)
									}
									.opacity(tappedCorrectAnswer ? 0.1 : 1)
									.disabled(tappedCorrectAnswer)
							}
						}
						.animation(.easeOut(duration: animateViewIn ? 1.5 : 0).delay(animateViewIn ? 2 : 0), value: animateViewIn)
						
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
									.rotationEffect(.degrees(hintWiggle ? 13 : 17))
									.transition(.offset(x: geo.size.width / 2))
									.onAppear {
										withAnimation(.easeInOut(duration: 0.1).repeatCount(9).delay(5).repeatForever()) {
											hintWiggle = true
										}
									}
									.onTapGesture {
										withAnimation(.easeOut(duration: 1)) {
											revealBook = true
										}
										playFlipSound()
										game.questionScore -= 1
									}
									.rotation3DEffect(.degrees(revealBook ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
									.scaleEffect(revealBook ? 5 : 1)
									.opacity(revealBook ? 0 : 1)
									.offset(x: revealBook ? -geo.size.width / 2 : 0)
									.overlay {
										Image("hp\(game.currentQuestion.book)")
											.resizable()
											.scaledToFit()
											.padding(.trailing)
											.opacity(revealBook ? 1 : 0)
											.scaleEffect(revealBook ? 1.8 : 1)
									}
									.opacity(tappedCorrectAnswer ? 0.1 : 1)
									.disabled(tappedCorrectAnswer)
								
							}
						}
						.animation(.easeInOut(duration: animateViewIn ? 1.5 : 0).delay(animateViewIn ? 2 : 0), value: animateViewIn)
					}
					.padding([.leading, .trailing], 20)
					.padding(.vertical, 40)

					// MARK: Answers
					LazyVGrid(columns: [GridItem(), GridItem()]) {
						ForEach(Array(game.answers.enumerated()), id:\.offset) { i, answer in
							//Correct Answers
							if game.currentQuestion.answers[answer] == true {
								VStack {
									if animateViewIn {
										if tappedCorrectAnswer == false {
											Text(answer)
												.minimumScaleFactor(0.5)
												.multilineTextAlignment(.center)
												.padding(10)
												.frame(width: geo.size.width / 2.15, height: 80)
												.background(.green.opacity(0.5))
												.cornerRadius(25)
												.transition(
													AsymmetricTransition(
														insertion: .scale,
														removal: .scale(5).combined(with: .opacity.animation(.easeOut(duration: 1)))
													)
												)
												.matchedGeometryEffect(id: "answer", in: namespace)
												.onTapGesture {
													withAnimation(.easeOut(duration: 1)) {
														tappedCorrectAnswer = true
													}
													playCorrectSound()
													
													DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
														game.correct()
													}
												}
										}
									}
									
								}
								.animation(.easeOut(duration: animateViewIn ? 1 : 0).delay(animateViewIn ? 1.5 : 0), value: animateViewIn)
							} else {
								// Wrong Answer
								VStack {
									if animateViewIn {
										Text(answer)
											.minimumScaleFactor(0.5)
											.multilineTextAlignment(.center)
											.padding(10)
											.frame(width: geo.size.width / 2.15, height: 80)
											.background(tappedWrongAnswers.contains(i) ? .red.opacity(0.5) : .green.opacity(0.5))
											.cornerRadius(25)
											.transition(.scale)
											.onTapGesture {
												withAnimation(.easeOut(duration: 1)) {
													tappedWrongAnswers.append(i)
												}
												playWrongSound()
												giveWrongFeedback()
												game.questionScore -= 1
											}
											.scaleEffect(tappedWrongAnswers.contains(i) ? 0.8 : 1)
											.disabled(tappedCorrectAnswer || tappedWrongAnswers.contains(i))
											.opacity(tappedCorrectAnswer ? 0.1 : 1)
									}
									
								}
								.animation(.easeOut(duration: animateViewIn ? 1 : 0).delay(animateViewIn ? 1.5 : 0), value: animateViewIn)

							}
								
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
							Text("\(game.questionScore)")
								.font(.largeTitle)
								.padding(.top, 30)
								.transition(.offset(y: -geo.size.height/4))
								.offset(x: movePointsToScores ? geo.size.width / 2.3 : 0 , y: movePointsToScores ? -geo.size.height / 13 : 0)
								.opacity(movePointsToScores ? 0 : 1)
								.onAppear {
									withAnimation(.easeInOut(duration: 1).delay(3)) {
										movePointsToScores = true
									}
								}
							
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
					.animation(.easeInOut(duration: tappedCorrectAnswer ? 1 : 0).delay(tappedCorrectAnswer ? 1 : 0), value: tappedCorrectAnswer)
					
					Spacer()
					
					if tappedCorrectAnswer  {
						Text(game.correctAnswer)
							.minimumScaleFactor(0.5)
							.multilineTextAlignment(.center)
							.padding(10)
							.frame(width: geo.size.width / 2.15, height: 80)
							.background(.green.opacity(0.5))
							.cornerRadius(25)
							.scaleEffect(2)
							.matchedGeometryEffect(id: "answer", in: namespace)
					}
					
					Spacer()
					
					VStack {
						if tappedCorrectAnswer {
							Button("Next Level >"){
								animateViewIn = false
								tappedCorrectAnswer = false
								revealHint = false
								revealBook = false
								movePointsToScores = false
								tappedWrongAnswers = []
								
								game.newQuestion()
								
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
									animateViewIn = true
								}
								
							}
							.buttonStyle(.borderedProminent)
							.font(.largeTitle)
							.tint(.blue.opacity(0.7))
							.transition(.offset(y: geo.size.height/2))
							.scaleEffect(scaleNextButton ? 1.2 : 1)
							.onAppear {
								withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
									scaleNextButton.toggle()
								}
							}
						}
					}
					.animation(.easeInOut(duration: tappedCorrectAnswer ? 2 : 0).delay(tappedCorrectAnswer ? 2.3 : 0), value: tappedCorrectAnswer)
					
					Spacer()
				}
				.foregroundColor(.white)
			}
			.frame(width: geo.size.width, height: geo.size.height)
		}
		.ignoresSafeArea()
		.onAppear {
			animateViewIn = true
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				playMusic()
			}
		}
    }
	
	private func playMusic() {
		let songs = ["let-the-mystery-unfold", "spellcraft", "hiding-place-in-the-forest", "deep-in-the-dell"]
		
		let i = Int.random(in: 0...3)
		
		if let sound = Bundle.main.path(forResource: songs[i], ofType: "mp3") {
			do {
				musicPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
				musicPlayer.volume = 0.1
				musicPlayer.numberOfLoops = -1 // play audio infinity; never stops
				musicPlayer.play()
			}catch {
				print("There was an issue playing the sound: \(error)")
			}
		} else {
			print("Couldn't find the sound file")
		}
		
	}
	
	private func playFlipSound() {
		if let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3"){
			do {
				sfxPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
				sfxPlayer.play()
			}catch {
				print("There was an issue playing the sound: \(error)")
			}
		} else {
			print("Couldn't find the sound file")
		}
	}
	
	private func playWrongSound() {
		if let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3"){
			do {
				sfxPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
				sfxPlayer.play()
			}catch {
				print("There was an issue playing the sound: \(error)")
			}
		} else {
			print("Couldn't find the sound file")
		}
	}

	
	private func playCorrectSound() {
		if let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3"){
			do {
				sfxPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
				sfxPlayer.play()
			}catch {
				print("There was an issue playing the sound: \(error)")
			}
		} else {
			print("Couldn't find the sound file")
		}
	}
	
	private func giveWrongFeedback() {
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.error)
	}


}

#Preview {
    GamePlayView()
		.environmentObject(GameViewModel())
}
