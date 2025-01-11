//
//  SettingsView.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/6/25.
//

import SwiftUI

struct SettingsView: View {
	@Environment(\.dismiss) private var dismiss
	@EnvironmentObject private var store: Store
	
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
						ForEach(0..<7) { i in
							if store.books[i] == .active || (store.books[i] == .locked && store.purchasedIDs.contains("hp\(i+1)")) {
								// Selected book
								ZStack(alignment: .bottomTrailing) {
									Image("hp\(i+1)")
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
								.task {
									store.books[i] = .active
									store.saveStatus()
								}
								.onTapGesture {
									store.books[i] = .inactive
									store.saveStatus()
								}
							} else if store.books[i] == .inactive {
								
								// Unselected Book
								ZStack(alignment: .bottomTrailing) {
									Image("hp\(i+1)")
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
								.onTapGesture {
									store.books[i] = .active
									store.saveStatus()
								}
							} else {
								// Unlocked Book
								ZStack{
									Image("hp\(i+1)")
										.resizable()
										.scaledToFit()
										.shadow(radius: 7)
										.overlay(Rectangle().opacity(0.7))
									
									Image(systemName: "lock.fill")
										.font(.largeTitle)
										.imageScale(.large)
										.foregroundColor(.black)
										.shadow(color:.white.opacity(0.7), radius: 7)
										.padding(5)
								}
								.onTapGesture {
									let product = store.products[i-3]
									Task {
										await store.purchase(product)
									}
								}
							}
					}
					}
					
				}
				
				Button("Done"){
					dismiss()
				}
				.doneButton()
			}
			.padding()
			.foregroundColor(.black)
		}
    }
}

#Preview {
	SettingsView().environmentObject(Store())
}
