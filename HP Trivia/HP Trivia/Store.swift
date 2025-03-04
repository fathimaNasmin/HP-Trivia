//
//  Store.swift
//  HP Trivia
//
//  Created by Fathima Nasmin on 1/9/25.
//

import Foundation
import StoreKit


enum BookStatus: Codable {
	case active
	case inactive
	case locked
}

@MainActor
class Store: ObservableObject {
	@Published var books:[BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
	@Published var products: [Product] = []
	@Published var purchasedIDs = Set<(String)>()
	
	private var productIDs = ["hp4", "hp5", "hp6", "hp7"]
	private var updates: Task<Void, Never>? = nil
	private let savePath = FileManager.documentDirectory.appending(path: "SavedBookStatus")
	
	init() {
		updates = watchForUpdate()
	}
	
	
	func loadProducts() async{
		do {
			products = try await Product.products(for: productIDs)
			products.sort {
				$0.displayName < $1.displayName
			}
		}catch {
			print("Could not fetch those products: \(error)")
		}
	}
	
	func purchase(_ product: Product) async{
		do {
			let result = try await product.purchase()
			
			switch result {
				// Purchase successfull, but need to verify the receipt
			case .success(let verificationResult):
				switch verificationResult {
				case .unverified(let signedType, let verificationError):
					print("Error on \(signedType) : \(verificationError)")
					
				case .verified(let signedType):
					purchasedIDs.insert(signedType.productID)
				}
			// User cancelled or parent disapproved child's request
			case .userCancelled:
				break
			// Wait for approval
			case .pending:
				break
				
			@unknown default:
				break
			}
		}catch {
			print("Couldn't purchase that product: \(error)")
		}
	}
	
	func saveStatus() {
		do {
			let data = try JSONEncoder().encode(books)
			try data.write(to: savePath)
		}catch{
			print("unable to save data: \(error)")
		}
	}
	
	func loadStatus() {
		do {
			let data = try Data(contentsOf: savePath)
			books = try JSONDecoder().decode([BookStatus].self, from: data)
		}catch{
			print("Couldn't load book status: \(error)")
		}
	}
	
	private func checkPurchased() async {
		for product in products {
			guard let state = await product.currentEntitlement else { return }
			
			switch state {
			case .unverified(let signedType, let verificationError):
				print("Error on \(signedType) : \(verificationError)")
			case .verified(let signedType):
				if signedType.revocationDate == nil{
					purchasedIDs.insert(signedType.productID)
				} else {
					purchasedIDs.remove(signedType.productID)
				}
			}
		}
	}
	
	private func watchForUpdate() -> Task<Void, Never> {
		Task(priority: .background) {
			for await _ in Transaction.updates {
				await checkPurchased()
			}
		}
	}
	
	
}
