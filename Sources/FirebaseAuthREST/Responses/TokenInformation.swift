import Foundation

public protocol TokenInformation: Decodable {

	var idToken: String { get }
	var refreshToken: String { get }
	var expirationDate: Date { get }

}

public extension TokenInformation {

	var isExpired: Bool {
		expirationDate <= Date()
	}

}
