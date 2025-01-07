//
//  GamePlayView.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/7/25.
//

import SwiftUI

struct GamePlayView: View {
    var body: some View {
		GeometryReader { geo in
			ZStack {
				Image("hogwarts")
					.resizable()
					.frame(width: geo.size.width * 3, height: geo.size.height * 1.03)
					.overlay(Rectangle().foregroundColor(.black.opacity(0.8)))
				
				VStack {
					HStack {
						Button("End Game"){
							// TODO: End game
						}
						.font(.title3)
						.foregroundColor(.white)
						.padding(10)
						.background(.red.opacity(0.75))
						.cornerRadius(10)
						
						Spacer()
						
						Text("Score: 20")
							.font(.title3)
					}
					.padding([.leading, .trailing], 20)
					.padding(.vertical, 60)
					
					
					Text("Who is Harry Potter?")
						.font(.custom(Constants.hpFont, size: 50))
						.padding()
						.multilineTextAlignment(.center)
						
					
					Spacer()
					
					HStack{
						Image(systemName: "questionmark.app.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 100)
							.foregroundColor(.cyan)
							.rotationEffect(.degrees(-15))
						
						Spacer()
						
						Image(systemName: "book.closed")
							.resizable()
							.scaledToFit()
							.frame(width: 50)
							.foregroundColor(.black)
							.frame(width: 100, height: 100)
							.background(.cyan)
							.cornerRadius(20)
							.rotationEffect(.degrees(15))
							
					}
					.padding([.leading, .trailing], 20)
					.padding(.vertical, 40)
				
					
					LazyVGrid(columns: [GridItem(), GridItem()]) {
						ForEach(1..<5){ i in
								Text("Answer \(i)")
								.minimumScaleFactor(0.5)
								.multilineTextAlignment(.center)
								.padding(10)
								.frame(width: geo.size.width / 2.15, height: 80)
								.background(.green.opacity(0.5))
								.cornerRadius(25)
						}
					}
					
					Spacer()
					
					
				}
				.frame(width: geo.size.width, height: geo.size.height)
				.foregroundColor(.white)
			}
			.frame(width: geo.size.width, height: geo.size.height)
		}
		.ignoresSafeArea()
    }
}

#Preview {
    GamePlayView()
}
