import Foundation
import HPNetwork

public final class FirebaseAuthSession {

	private let apiKey: String
	private let finishingQueue: DispatchQueue

	public init(apiKey: String, finishingQueue: DispatchQueue = .main) {
		self.apiKey = apiKey
		self.finishingQueue = finishingQueue
	}

	// MARK: - Email Login

	public func signIn(with credentials: EmailCredentials, completion: @escaping (Result<EmailAuthResponse, Error>) -> Void) {
		let request = EmailSignInRequest(apiKey: apiKey, payload: credentials, finishingQueue: finishingQueue)
		Network.shared.dataTask(request, completion: completion)
	}

	public func signUp(with credentials: EmailCredentials, completion: @escaping (Result<EmailAuthResponse, Error>) -> Void) {
		let request = EmailSignUpRequest(apiKey: apiKey, payload: credentials, finishingQueue: finishingQueue)
		Network.shared.dataTask(request, completion: completion)
	}

	// MARK: - Anonymous Login

	public func signInAnonymously(completion: @escaping (Result<EmailAuthResponse, Error>) -> Void) {
		let request = AnonymousSignInRequest(apiKey: apiKey)
		Network.shared.dataTask(request, completion: completion)
	}

	// MARK: - Token Refreshing

	public func refreshToken(with refreshToken: String, completion: @escaping (Result<AuthTokenResponse, Error>) -> Void) {
		let request = TokenRefreshRequest(apiKey: apiKey, refreshToken: refreshToken, finishingQueue: finishingQueue)
		Network.shared.dataTask(request, completion: completion)
	}

	// MARK: - Token Exchange

	public func exchangeCustomToken(_ customToken: String, completion: @escaping (Result<FirebaseIDToken, Error>) -> Void) {
		let request = TokenExchangeRequest(apiKey: apiKey, token: customToken, finishingQueue: finishingQueue)
		Network.shared.dataTask(request, completion: completion)
	}

}
