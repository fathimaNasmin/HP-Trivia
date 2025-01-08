//
//  Constants.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/6/25.
//

import Foundation
import SwiftUI

enum Constants {
	static let hpFont = "PartyLetPlain"
}

struct InstructionBackground: View {
	var body: some View {
		Image("parchment")
			.resizable()
			.ignoresSafeArea()
			.background(.brown)
	}
}


extension Button {
	func doneButton() -> some View {
		self
			.font(.title)
			.padding()
			.buttonStyle(.borderedProminent)
			.foregroundColor(.white)
			.tint(.brown)
	}
}
