import Foundation
import HPNetwork

public final class FirebaseAuthSession {

	let apiKey: String

	public init(apiKey: String) {
		self.apiKey = apiKey
	}

	public func signIn(with payload: EmailSignInCredentials, completion: @escaping (Result<TokenInformation, Error>) -> Void) {
		let request = EmailSignInRequest(apiKey: apiKey, payload: payload)
		Network.shared.dataTask(request, completion: completion)
	}

	public func refreshToken(with refreshToken: String, completion: @escaping (Result<TokenInformation, Error>) -> Void) {
		let request = TokenRefreshRequest(apiKey: apiKey, refreshToken: refreshToken)
		Network.shared.dataTask(request, completion: completion)
	}

}
