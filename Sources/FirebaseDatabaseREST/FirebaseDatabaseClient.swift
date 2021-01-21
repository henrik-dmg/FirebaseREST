import Foundation
import FirebaseAuthREST
import HPNetwork

public final class FirebaseDatabaseClient {

	public typealias TokenResult = (Result<EmailAuthResponse, Error>) -> Void

	// MARK: - Properties

	let host: String

	private let session: FirebaseAuthSession?
	private let finishingQueue: DispatchQueue
	private var emailCredentials: EmailCredentials?
	private var lastToken: EmailAuthResponse?

	// MARK: - Init

	public init(host: String, apiKey: String?, emailCredentials: EmailCredentials? = nil, finishingQueue: DispatchQueue = .main) {
		self.host = host
		self.finishingQueue = finishingQueue
		self.emailCredentials = emailCredentials

		if let apiKey = apiKey {
			self.session = FirebaseAuthSession(apiKey: apiKey, finishingQueue: finishingQueue)
		} else {
			self.session = nil
		}
	}

	// MARK: - User Change

	public func authenticateNewUser(with credentials: EmailCredentials, completion: @escaping TokenResult) {
		guard credentials != emailCredentials else {
			refreshTokenIfNecessary(completion: completion)
			return
		}
		requestNewToken(for: credentials, completion: completion)
	}

	// MARK: - Token Refreshing

	private func refreshTokenIfNecessary(completion: @escaping TokenResult) {
		if let token = lastToken, !token.isExpired {
			completion(.success(token))
			return
		}

		guard let credentials = emailCredentials else {
			completion(.failure(NSError.noCredentialsError))
			return
		}

		requestNewToken(for: credentials, completion: completion)
	}

	private func requestNewToken(for credentials: EmailCredentials, completion: @escaping TokenResult) {
		guard let session = session else {
			completion(.failure(NSError.noSessionError))
			return
		}
		session.signIn(with: credentials) { [weak self] result in
			if case .success(let response) = result {
				self?.lastToken = response
			}
			completion(result)
		}
	}

	// MARK: - Obtaining Reference

	public func path() -> DatabasePath {
		DatabasePath(components: [])
	}

}

// MARK: - Querying

extension FirebaseDatabaseClient {

	public func performQuery<Query: DatabaseQuery>(_ query: Query, completion: @escaping (Result<Query.Request.Output, Error>) -> Void) {
		let host = self.host
		let queue = finishingQueue
		refreshTokenIfNecessary { result in
			switch result {
			case .success(let response):
				let request = query.makeNetworkRequest(host: host, idToken: response.idToken, finishingQueue: queue)
				Network.shared.schedule(request: request, completion: completion)
			case .failure(let error as NSError):
				if error == NSError.noSessionError || error == NSError.noCredentialsError {
					let request = query.makeNetworkRequest(host: host, idToken: nil, finishingQueue: queue)
					Network.shared.schedule(request: request, completion: completion)
				} else {
					completion(.failure(error))
				}
			}
		}
	}

}

extension NSError {

	static let noSessionError = NSError(code: 30, description: "No session was provided")
	static let noCredentialsError = NSError(code: 31, description: "No email credentials were provided")

}
