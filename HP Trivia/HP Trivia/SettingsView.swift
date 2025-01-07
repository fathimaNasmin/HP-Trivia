//
//  SettingsView.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/6/25.
//

import SwiftUI

struct SettingsView: View {
	@Environment(\.dismiss) private var dismiss
	
    var body: some View {
		ZStack {
			InstructionBackground()
			
			VStack {
				Text("Which books would you like questions from?")
					.font(.largeTitle)
					.foregroundColor(.black)
					.multilineTextAlignment(.center)
				
				ScrollView {
					LazyVGrid(columns: [GridItem(), GridItem()]) {
						// Selected book
						ZStack(alignment: .bottomTrailing) {
							Image("hp1")
								.resizable()
								.scaledToFit()
								.shadow(radius: 7)
							
							Image(systemName: "checkmark.circle.fill")
								.font(.largeTitle)
								.imageScale(.large)
								.shadow(radius: 7)
								.foregroundColor(.green)
								.padding(5)
						}
						
						// Unselected Book
						ZStack(alignment: .bottomTrailing) {
							Image("hp2")
								.resizable()
								.scaledToFit()
								.shadow(radius: 7)
								.overlay(Rectangle().opacity(0.33))
							
							Image(systemName: "circle")
								.font(.largeTitle)
								.imageScale(.large)
								.foregroundColor(.green.opacity(0.5))
								.shadow(radius: 7)
								.padding(5)
						}
						
						// Unlocked Book
						ZStack{
							Image("hp3")
								.resizable()
								.scaledToFit()
								.shadow(radius: 7)
								.overlay(Rectangle().opacity(0.7))
							
							Image(systemName: "lock.fill")
								.font(.largeTitle)
								.imageScale(.large)
								.shadow(color:.white.opacity(0.7), radius: 3)
								.padding(5)
						}
					}
					
				}
				
				Button("Done"){
					dismiss()
				}
				.doneButton()
			}
			.padding()
		}
    }
}

#Preview {
    SettingsView()
}
