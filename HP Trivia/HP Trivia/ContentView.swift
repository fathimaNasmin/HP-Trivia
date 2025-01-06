//
//  ContentView.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/5/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
	
	@State private var audioPlayer: AVAudioPlayer!
	@State private var scalePlayButton = false
	@State private var moveBackgroundImage = false
	@State private var animateViewsIn = false
	@State private var showInstruction = false
	
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
									// Play button action
								} label: {
									Text("Play")
										.font(.title)
										.foregroundColor(.white)
										.padding(.vertical, 7)
										.padding(.horizontal, 50)
										.background(.brown)
										.cornerRadius(7)
								}
								.scaleEffect(scalePlayButton ? 1.2 : 1)
								.onAppear {
									withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
										scalePlayButton.toggle()
									}
								}
								.transition(.offset(y: geo.size.height / 3))
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
						
						
						Spacer()
						
						// settings button
						VStack {
							if animateViewsIn {
								Button {
									// settings action
								} label: {
									Image(systemName: "gearshape.fill")
										.font(.largeTitle)
										.foregroundColor(.white)
										.shadow(color: .black, radius: 5)
								}
								.transition(.offset(x: geo.size.width / 4))
							}
						}
						.animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
						
						
						Spacer()
					}
					.frame(width: geo.size.width)
					
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
}

#Preview {
    ContentView()
}
