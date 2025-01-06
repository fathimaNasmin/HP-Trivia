//
//  ContentView.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/5/25.
//

import SwiftUI

struct ContentView: View {
	
	@State private var scalePlayButton = false
	
    var body: some View {
		GeometryReader { geo in
			ZStack {
				Image("hogwarts")
					.resizable()
					.frame(width: geo.size.width * 3, height: geo.size.height)
					.padding(.top, 3)
				
				VStack {
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
					
					Spacer()
					
					// score board
					
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
					
					Spacer()
					
					HStack {
						Spacer()
						
						Button {
							// show instruction screen
						} label: {
							Image(systemName: "info.circle.fill")
								.font(.largeTitle)
								.foregroundColor(.white)
								.shadow(color: .black, radius: 5)
						}
						
						Spacer()
						
						//Play button
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
						
						Spacer()
						
						// settings button
						Button {
							// settings action
						} label: {
							Image(systemName: "gearshape.fill")
								.font(.largeTitle)
								.foregroundColor(.white)
								.shadow(color: .black, radius: 5)
						}
						
						Spacer()
					}
					.frame(width: geo.size.width)
					
					Spacer()
				}
			}
			.frame(width: geo.size.width, height: geo.size.height)
			
		}
		.ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
