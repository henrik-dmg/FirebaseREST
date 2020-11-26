import Foundation

public protocol FirebaseToken: Decodable {

	/// A Firebase Auth ID token for the authenticated user.
	var idToken: String { get }

	/// A Firebase Auth refresh token for the authenticated user
	/// that can be exchanged for a new ID Token
	var refreshToken: String { get }

	/// The expiration date of the `idToken`
	var expirationDate: Date { get }

}

public extension FirebaseToken {

	/// Boolean indicating whether the ID Token is expired
	var isExpired: Bool {
		expirationDate <= Date()
	}

}
