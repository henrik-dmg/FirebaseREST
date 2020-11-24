import Foundation
import HPNetwork

public struct DatabaseReference {

	// MARK: - Properties

	let host: String
	let components: [String]

	// MARK: - Init

	public init(host: String) {
		self.host = host
		self.components = []
	}

	private init(host: String, components: [String]) {
		self.host = host
		self.components = components
	}

	// MARK: - Building Path

	public func child(_ path: String) -> DatabaseReference {
		let newComponents = components + [path]
		return DatabaseReference(host: host, components: newComponents)
	}

	// MARK: - CRUD

	public func saveObject<E: Encodable>(_ value: E, receiveOn finishingQueue: DispatchQueue = .main, completion: @escaping (Error?) -> Void) {
		let request = SaveRequest(host: host, pathComponents: components, value: value, isUpdate: false, finishingQueue: finishingQueue)
		performNoReturnOperation(request: request, completion: completion)
	}

	public func updateObject<E: Encodable>(_ value: E, receiveOn finishingQueue: DispatchQueue = .main, completion: @escaping (Error?) -> Void) {
		let request = SaveRequest(host: host, pathComponents: components, value: value, isUpdate: true, finishingQueue: finishingQueue)
		performNoReturnOperation(request: request, completion: completion)
	}

	public func deleteObject(receiveOn finishingQueue: DispatchQueue = .main, completion: @escaping (Error?) -> Void) {
		let request = DeleteRequest(host: host, pathComponents: components, finishingQueue: finishingQueue)
		performNoReturnOperation(request: request, completion: completion)
	}

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

	public func retrieveObject<D: Decodable>(
		resultType: D.Type,
		decoder: JSONDecoder = .init(),
		receiveOn finishingQueue: DispatchQueue = .main,
		completion: @escaping (Result<D, Error>) -> Void)
	{
		let request = RetrieveRequest<D>(host: host, pathComponents: components, decoder: decoder, finishingQueue: finishingQueue)
		Network.shared.dataTask(request, completion: completion)
	}

}
