import Foundation

struct FirebaseAuthError: Decodable {

	enum TopLevelKey: String, CodingKey {
		case error
	}

	enum CodingKeys: String, CodingKey {
		case code
		case reason = "message"
	}

	public enum Reason: String, Decodable {
		case emailNotFound = "EMAIL_NOT_FOUND"
		case invalidPassword = "INVALID_PASSWORD"
		case userDisabled = "USER_DISABLED"
		case emailExists = "EMAIL_EXISTS"
		case operationNotAllowed = "OPERATION_NOT_ALLOWED"
		case tooManyAttempts = "TOO_MANY_ATTEMPTS_TRY_LATER"
		case invalidCustomToken = "INVALID_CUSTOM_TOKEN"
		case credentialMismatch = "CREDENTIAL_MISMATCH"
		case tokenExpired = "TOKEN_EXPIRED"
		case userNotFound = "USER_NOT_FOUND"
//		API key not valid. Please pass a valid API key. (invalid API key provided)
		case invalidRefreshToken = "INVALID_REFRESH_TOKEN"
//		Invalid JSON payload received. Unknown name \"refresh_tokens\": Cannot bind query parameter. Field 'refresh_tokens' could not be found in request message.
		case invalidGrantType = "INVALID_GRANT_TYPE"
		case missingRefreshToken = "MISSING_REFRESH_TOKEN"


		public var errorMessage: String {
			switch self {
			case .emailNotFound:
				return "There is no user record corresponding to this identifier. The user may have been deleted."
			case .invalidPassword:
				return "The password is invalid or the user does not have a password."
			case .userDisabled:
				return "The user account has been disabled by an administrator."
			case .emailExists:
				return "The email address is already in use by another account."
			case .operationNotAllowed:
				return "Password sign-in is disabled for this project."
			case .tooManyAttempts:
				return "Firebase has blocked all requests from this device due to unusual activity. Try again later."
			case .invalidCustomToken:
				return "The custom token format is incorrect or the token is invalid for some reason (e.g. expired, invalid signature etc.)"
			case .credentialMismatch:
				return "The custom token corresponds to a different Firebase project."
			case .tokenExpired:
				return "The user's credential is no longer valid. The user must sign in again."
			case .userNotFound:
				return "The user corresponding to the refresh token was not found. It is likely the user was deleted."
			case .invalidRefreshToken:
				return "An invalid refresh token was provided."
			case .invalidGrantType:
				return "The specified grant type was invalid"
			case .missingRefreshToken:
				return "No refresh token provided."
			}
		}
	}

	let code: Int
	let reason: Reason

	var nsError: NSError {
		NSError(code: code, description: reason.errorMessage)
	}

	init(from decoder: Decoder) throws {
		let outerContainer = try decoder.container(keyedBy: TopLevelKey.self)
			.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
		self.code = try outerContainer.decode(Int.self, forKey: .code)
		self.reason = try outerContainer.decode(Reason.self, forKey: .reason)
	}

}
