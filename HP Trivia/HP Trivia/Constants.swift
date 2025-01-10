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
	
	static let previewQuestion = try! JSONDecoder().decode([Question].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0]
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

extension FileManager {
	static var documentDirectory: URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
}
