import Foundation

public struct FirebaseIDToken: FirebaseToken {

	enum CodingKeys: String, CodingKey {
		case localID = "localId"
		case email
		case displayName
		case idToken
		case refreshToken
		case expiresIn
	}

	public let idToken: String
	public let refreshToken: String
	public let expirationDate: Date

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		refreshToken = try container.decode(String.self, forKey: .refreshToken)
		idToken = try container.decode(String.self, forKey: .idToken)

		let expiresString = try container.decode(String.self, forKey: .expiresIn)
		guard let expiresSecond = Double(expiresString) else {
			throw NSError(description: "Could not convert \"\(expiresString)\" to an Integer")
		}
		expirationDate = Date().addingTimeInterval(expiresSecond - 2.00)
	}

}
