//
//  ContentView.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/5/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
	@EnvironmentObject private var store: Store
	@EnvironmentObject private var game: GameViewModel
	
	@State private var audioPlayer: AVAudioPlayer!
	@State private var scalePlayButton = false
	@State private var moveBackgroundImage = false
	@State private var animateViewsIn = false
	@State private var showInstruction = false
	@State private var showSettings = false
	@State private var playGame = false
	
    var body: some View {
		GeometryReader { geo in
			ZStack {
				Image("hogwarts")
					.resizable()
					.frame(width: geo.size.width * 3, height: geo.size.height)
					.padding(.top, 3)
					.offset(x: moveBackgroundImage ? geo.size.width/1.1 : -geo.size.width/1.1 )
					.onAppear {
						withAnimation(.linear(duration: 60).repeatForever()) {
							moveBackgroundImage.toggle()
						}
					}
				
				VStack {
					VStack {
						if animateViewsIn {
							VStack {
								Image(systemName: "bolt.fill")
									.font(.largeTitle)
									.imageScale(.large)
								
								Text("HP")
									.font(.custom(Constants.hpFont, size: 70))
									.padding(.bottom, -50)
								
								Text("Trivia")
									.font(.custom(Constants.hpFont, size: 60))
							}
							.padding(.top, 70)
							.transition(.move(edge: .top))
						}
					}
					.animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
					
					Spacer()
					 
					// score board
					VStack {
						if animateViewsIn {
							VStack {
								Text("Recent Scores")
									.font(.title2)
								
								Text("33")
								Text("23")
								Text("12")
							}
							.font(.title3)
							.padding(.horizontal)
							.foregroundColor(.white)
							.background(.black.opacity(0.7))
							.cornerRadius(10)
							.transition(.opacity)
						}
					}
					.animation(.linear(duration: 1).delay(4), value: animateViewsIn)
					
					
					Spacer()
					
					HStack {
						Spacer()
						
						// Info button
						VStack {
							if animateViewsIn {
								Button {
									// show instruction screen
									showInstruction.toggle()
								} label: {
									Image(systemName: "info.circle.fill")
										.font(.largeTitle)
										.foregroundColor(.white)
										.shadow(color: .black, radius: 5)
								}
								.transition(.offset(x: -geo.size.width/4))
								.sheet(isPresented: $showInstruction) {
									InstructionView()
								}
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
						
						  
						Spacer()
						
						//Play button
						VStack {
							if animateViewsIn {
								Button {
									filterQuestion()
									game.startGame()
									playGame.toggle()
								} label: {
									Text("Play")
										.font(.title)
										.foregroundColor(.white)
										.padding(.vertical, 7)
										.padding(.horizontal, 50)
										.background(store.books.contains(.active) ? .brown : .gray)
										.cornerRadius(7)
								}
								.scaleEffect(scalePlayButton ? 1.2 : 1)
								.onAppear {
									withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
										scalePlayButton.toggle()
									}
								}
								.transition(.offset(y: geo.size.height / 3))
								.fullScreenCover(isPresented: $playGame) {
									GamePlayView()
										.environmentObject(game)
								}
								.disabled(store.books.contains(.active) ? false : true)
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
						
						
						
						Spacer()
						
						// settings button
						VStack {
							if animateViewsIn {
								Button {
									// settings action
									showSettings.toggle()
								} label: {
									Image(systemName: "gearshape.fill")
										.font(.largeTitle)
										.foregroundColor(.white)
										.shadow(color: .black, radius: 5)
								}
								.transition(.offset(x: geo.size.width / 4))
								.sheet(isPresented: $showSettings) {
									SettingsView().environmentObject(store)
								}
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
						
						
						Spacer()
					}
					.frame(width: geo.size.width)
					
					// No books selected
					VStack {
						if animateViewsIn {
							if store.books.contains(.active) == false {
								Text("No questions available. Go to settings⬆️")
									.multilineTextAlignment(.center)
									.transition(.opacity)
							}
						}
					}
					.animation(.easeInOut.delay(3), value: animateViewsIn)
					
					Spacer()
				}
			}
			.frame(width: geo.size.width, height: geo.size.height)
			
		}
		.ignoresSafeArea()
		.onAppear() {
			animateViewsIn = true
//			playAudio()
		}
    }
	
	// Function to initialize and play audio.
	private func playAudio() {
		if let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3") {
			do {
				audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
				audioPlayer.numberOfLoops = -1 // play audio infinity; never stops
				audioPlayer.play()
			}catch {
				print("There was an issue playing the sound: \(error)")
			}
		} else {
			print("Couldn't find the sound file")
		}
		
	}
	
	private func filterQuestion(){
		var books: [Int] = []
		
		for (index, status) in store.books.enumerated() {
			if status == .active {
				books.append(index+1)
			}
		}
		
		game.filterQuestions(to: books)
		game.newQuestion()
	}
}

#Preview {
	ContentView()
		.environmentObject(Store())
		.environmentObject(GameViewModel())
}
