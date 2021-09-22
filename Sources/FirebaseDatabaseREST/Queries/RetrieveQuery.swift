import Foundation

public struct RetrieveQuery<D: Decodable>: DatabaseQuery {

	public typealias QueryOutput = D

	public let path: DatabasePath
	public let filter: DatabaseQueryFilter?
	public let decoder: JSONDecoder

	public init(path: DatabasePath, filter: DatabaseQueryFilter?, decoder: JSONDecoder = .init()) {
		self.path = path
		self.filter = filter
		self.decoder = decoder
	}

}

extension RetrieveQuery {

	public func makeNetworkRequest(host: String, idToken: String?) -> RetrieveRequest<D> {
		RetrieveRequest(
			host: host,
			path: path,
			filter: filter,
			decoder: decoder,
			idToken: idToken
		)
	}

}
