import Foundation

public struct EmailCredentials: Encodable, Equatable {

	public let email: String
	public let password: String
	private let returnSecureToken = true

	public init(email: String, password: String) {
		self.email = email
		self.password = password
	}

}
