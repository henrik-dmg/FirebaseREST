import Foundation
import HPNetwork

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public final class FirebaseAuthSession {

	private let apiKey: String

	public init(apiKey: String) {
		self.apiKey = apiKey
	}

	// MARK: - Email Login

	public func signIn(with credentials: EmailCredentials, delegate: URLSessionDataDelegate? = nil) async throws -> EmailAuthResponse {
		let request = EmailSignInRequest(apiKey: apiKey, payload: credentials)
		return try await request.response(delegate: delegate).output
	}

	public func signUp(with credentials: EmailCredentials, delegate: URLSessionDataDelegate? = nil) async throws -> EmailAuthResponse {
		let request = EmailSignUpRequest(apiKey: apiKey, payload: credentials)
		return try await request.response(delegate: delegate).output
	}

	// MARK: - Anonymous Login

	public func signInAnonymously(delegate: URLSessionDataDelegate? = nil) async throws -> EmailAuthResponse {
		let request = AnonymousSignInRequest(apiKey: apiKey)
		return try await request.response(delegate: delegate).output
	}

	// MARK: - Token Refreshing

	public func refreshToken(with refreshToken: String, delegate: URLSessionDataDelegate? = nil) async throws -> AuthTokenResponse {
		let request = TokenRefreshRequest(apiKey: apiKey, refreshToken: refreshToken)
		return try await request.response(delegate: delegate).output
	}

	// MARK: - Token Exchange

	public func exchangeCustomToken(_ customToken: String, delegate: URLSessionDataDelegate? = nil) async throws -> FirebaseIDToken {
		let request = TokenExchangeRequest(apiKey: apiKey, token: customToken)
		return try await request.response(delegate: delegate).output
	}

}
