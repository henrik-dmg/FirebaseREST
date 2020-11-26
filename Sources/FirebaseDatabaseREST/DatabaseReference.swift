import Foundation
import HPNetwork
import FirebaseAuthREST

public class DatabaseReference {

	// MARK: - Properties

	typealias TokenResult = (Result<EmailAuthResponse, Error>) -> Void

	let host: String
	let emailCredentials: EmailCredentials?
	let components: [String]

	private let session: FirebaseAuthSession?
	private var lastToken: EmailAuthResponse?

	// MARK: - Init

	public init(host: String, apiKey: String? = nil, emailCredentials: EmailCredentials? = nil) {
		self.host = host
		self.emailCredentials = emailCredentials
		self.components = []

		if let apiKey = apiKey {
			self.session = FirebaseAuthSession(apiKey: apiKey)
		} else {
			self.session = nil
		}
	}

	private init(host: String, emailCredentials: EmailCredentials?, components: [String], session: FirebaseAuthSession?) {
		self.host = host
		self.emailCredentials = emailCredentials
		self.components = components
		self.session = session
	}

	// MARK: - Building Path

	public func child(_ path: String) -> DatabaseReference {
		let newComponents = components + [path]
		return DatabaseReference(
			host: host,
			emailCredentials: emailCredentials,
			components: newComponents,
			session: session
		)
	}

	// MARK: - Saving Object

	public func saveObject<E: Encodable>(_ value: E, encoder: JSONEncoder = .init(), completion: @escaping (Error?) -> Void) {
		refreshTokenIfNecessary { [weak self] result in
			switch result {
			case .success(let token):
				self?.saveObject(value, encoder: encoder, idToken: token.idToken, completion: completion)
			case .failure(let error as NSError):
				if error == NSError.noSessionError {
					self?.saveObject(value, encoder: encoder, idToken: nil, completion: completion)
				} else {
					completion(error)
				}
			}
		}
	}

	private func saveObject<E: Encodable>(_ value: E, encoder: JSONEncoder, idToken: String?, completion: @escaping (Error?) -> Void) {
		let request = SaveRequest(
			host: host,
			pathComponents: components,
			value: value,
			isUpdate: false,
			encoder: JSONEncoder(),
			idToken: idToken
		)
		performNoReturnOperation(request: request, completion: completion)
	}

	// MARK: - Updating

	public func updateObject<E: Encodable>(_ value: E, encoder: JSONEncoder = .init(), completion: @escaping (Error?) -> Void) {
		refreshTokenIfNecessary { [weak self] result in
			switch result {
			case .success(let token):
				self?.updateObject(value, encoder: encoder, idToken: token.idToken, completion: completion)
			case .failure(let error as NSError):
				if error == NSError.noSessionError {
					self?.updateObject(value, encoder: encoder, idToken: nil, completion: completion)
				} else {
					completion(error)
				}
			}
		}
	}

	private func updateObject<E: Encodable>(_ value: E, encoder: JSONEncoder, idToken: String?, completion: @escaping (Error?) -> Void) {
		let request = SaveRequest(
			host: host,
			pathComponents: components,
			value: value,
			isUpdate: true,
			encoder: JSONEncoder(),
			idToken: idToken
		)
		performNoReturnOperation(request: request, completion: completion)
	}

	// MARK: - Deleting

	public func deleteObject(completion: @escaping (Error?) -> Void) {
		refreshTokenIfNecessary { [weak self] result in
			switch result {
			case .success(let token):
				self?.deleteObject(idToken: token.idToken, completion: completion)
			case .failure(let error as NSError):
				if error == NSError.noSessionError {
					self?.deleteObject(idToken: nil, completion: completion)
				} else {
					completion(error)
				}
			}
		}
	}

	private func deleteObject(idToken: String?, completion: @escaping (Error?) -> Void) {
		let request = DeleteRequest(
			host: host,
			pathComponents: components,
			idToken: idToken
		)
		performNoReturnOperation(request: request, completion: completion)
	}

	// MARK: - Retrieving

	public func retrieveObject<D: Decodable>(
		resultType: D.Type,
		decoder: JSONDecoder = .init(),
		completion: @escaping (Result<D, Error>) -> Void)
	{
		refreshTokenIfNecessary { [weak self] result in
			switch result {
			case .success(let token):
				self?.retrieveObject(resultType: resultType, decoder: decoder, idToken: token.idToken, completion: completion)
			case .failure(let error as NSError):
				if error == NSError.noSessionError {
					self?.retrieveObject(resultType: resultType, decoder: decoder, idToken: nil, completion: completion)
				} else {
					completion(.failure(error))
				}
			}
		}
	}

	private func retrieveObject<D: Decodable>(
		resultType: D.Type,
		decoder: JSONDecoder,
		idToken: String?,
		completion: @escaping (Result<D, Error>) -> Void)
	{
		let request = RetrieveRequest<D>(
			host: host,
			pathComponents: components,
			decoder: decoder,
			idToken: idToken
		)
		Network.shared.dataTask(request, completion: completion)
	}

	// MARK: - No Return

	private func performNoReturnOperation<N: NetworkRequest>(request: N, completion: @escaping (Error?) -> Void) {
		Network.shared.dataTask(request) { result in
			switch result {
			case .success:
				completion(nil)
			case .failure(let error):
				completion(error)
			}
		}
	}

	// MARK: - Token Refreshing

	private func refreshTokenIfNecessary(completion: @escaping TokenResult) {
		guard let token = lastToken, !token.isExpired else {
			requestNewToken(completion: completion)
			return
		}
		completion(.success(token))
	}

	private func requestNewToken(completion: @escaping TokenResult) {
		guard let session = session, let credentials = emailCredentials else {
			completion(.failure(NSError.noSessionError))
			return
		}
		session.signIn(with: credentials, completion: completion)
	}

}

extension NSError {

	static let noSessionError = NSError(code: 30, description: "No session or credentials were provided")

}
