import Foundation
import FirebaseAuthREST
import HPNetwork

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public final class FirebaseDatabaseClient {

	public typealias TokenResult = (Result<EmailAuthResponse, Error>) -> Void

	// MARK: - Properties

	let host: String

	private let session: FirebaseAuthSession?
	private var emailCredentials: EmailCredentials?
	private var lastToken: EmailAuthResponse?

	// MARK: - Init

	public init(host: String, apiKey: String?, emailCredentials: EmailCredentials? = nil) {
		self.host = host
		self.emailCredentials = emailCredentials

		if let apiKey = apiKey {
			self.session = FirebaseAuthSession(apiKey: apiKey)
		} else {
			self.session = nil
		}
	}

	// MARK: - User Change

	public func authenticateNewUser(with credentials: EmailCredentials, delegate: URLSessionDataDelegate? = nil) async throws -> EmailAuthResponse {
		guard credentials != emailCredentials else {
			return try await refreshTokenIfNecessary(delegate: delegate)
		}
		return try await requestNewToken(for: credentials, delegate: delegate)
	}

	// MARK: - Token Refreshing

	private func refreshTokenIfNecessary(delegate: URLSessionDataDelegate? = nil) async throws -> EmailAuthResponse {
		if let token = lastToken, !token.isExpired {
			return token
		}

		guard let credentials = emailCredentials else {
			throw NSError.noCredentialsError
		}

		return try await requestNewToken(for: credentials, delegate: delegate)
	}

	private func requestNewToken(for credentials: EmailCredentials, delegate: URLSessionDataDelegate? = nil) async throws -> EmailAuthResponse {
		guard let session = session else {
			throw NSError.noSessionError
		}
		let response = try await session.signIn(with: credentials, delegate: delegate)
		self.lastToken = response
		return response
	}

	// MARK: - Obtaining Reference

	public func path() -> DatabasePath {
		DatabasePath(components: [])
	}


	// MARK: - Querying

	public func performQuery<Query: DatabaseQuery>(_ query: Query, delegate: URLSessionDataDelegate? = nil) async throws -> Query.Request.Output {
		let host = self.host

		do {
			let token = try await refreshTokenIfNecessary(delegate: delegate)
			let request = query.makeNetworkRequest(host: host, idToken: token.idToken)
			return try await request.response(delegate: delegate).output
		} catch let error as NSError {
			if error == NSError.noSessionError || error == NSError.noCredentialsError {
				let request = query.makeNetworkRequest(host: host, idToken: nil)
				return try await request.response(delegate: delegate).output
			} else {
				throw error
			}
		}
	}

}

extension NSError {

	static let noSessionError = NSError(code: 30, description: "No session was provided")
	static let noCredentialsError = NSError(code: 31, description: "No email credentials were provided")

}
