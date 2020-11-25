import Foundation

public struct FirebaseTokenResponse: TokenInformation {

	// MARK: - CodingKeys

	enum CodingKeys: String, CodingKey {
		case tokenType = "token_type"
		case refreshToken = "refresh_token"
		case userID = "user_id"
		case projectID = "project_id"
		case accessToken = "access_token"
		case idToken = "id_token"
		case expiresIn = "expires_in"
	}

	// MARK: - Properties

	/// The type of the refresh token, always "Bearer".
	public let tokenType: String

	/// The Firebase Auth refresh token provided in the request or a new refresh token.
	public let refreshToken: String

	/// The uid corresponding to the provided ID token.
	public let userID: String

	/// Your Firebase project ID.
	public let projectID: String

	public let accessToken: String

	/// A Firebase Auth ID token.
	public let idToken: String

	/// The expiration date of the `idToken`
	public let expirationDate: Date

	// MARK: - Init

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		tokenType = try container.decode(String.self, forKey: .tokenType)
		refreshToken = try container.decode(String.self, forKey: .refreshToken)
		userID = try container.decode(String.self, forKey: .userID)
		projectID = try container.decode(String.self, forKey: .projectID)
		accessToken = try container.decode(String.self, forKey: .accessToken)
		idToken = try container.decode(String.self, forKey: .idToken)

		let expiresString = try container.decode(String.self, forKey: .expiresIn)
		guard let expiresSecond = Double(expiresString) else {
			throw NSError(description: "Could not convert \"\(expiresString)\" to an Integer")
		}
		expirationDate = Date().addingTimeInterval(expiresSecond - 2.00)
	}

}
