import Foundation

public struct FirebaseAuthResponse: TokenInformation {

	// MARK: - CodingKeys

	enum CodingKeys: String, CodingKey {
		case localID = "localId"
		case email
		case displayName
		case idToken
		case refreshToken
		case expiresIn
	}

	// MARK: - Properties

	let localID: String
	let email: String
	let displayName: String
	public let idToken: String
	public let refreshToken: String
	public let expirationDate: Date

	// MARK: - Init

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		localID = try container.decode(String.self, forKey: .localID)
		email = try container.decode(String.self, forKey: .email)
		displayName = try container.decode(String.self, forKey: .displayName)
		idToken = try container.decode(String.self, forKey: .idToken)
		refreshToken = try container.decode(String.self, forKey: .refreshToken)

		let expiresString = try container.decode(String.self, forKey: .expiresIn)
		guard let expiresSecond = Double(expiresString) else {
			throw NSError(description: "Could not convert \"\(expiresString)\" to an Integer")
		}
		expirationDate = Date().addingTimeInterval(expiresSecond - 2.00)
	}

}
