import Foundation
import HPNetwork

public struct UpdateQuery<E: Encodable>: DatabaseQuery {
	public typealias Request = UpdateRequest<E>


	public typealias QueryOutput = Data

	public let value: E
	public let encoder: JSONEncoder
	public let path: DatabasePath
	public let filter: DatabaseQueryFilter?

	public init(value: E, encoder: JSONEncoder = .init(), path: DatabasePath, filter: DatabaseQueryFilter?) {
		self.value = value
		self.encoder = encoder
		self.path = path
		self.filter = filter
	}

}

extension UpdateQuery {

	public func makeNetworkRequest(host: String, idToken: String?) -> UpdateRequest<E> {
		UpdateRequest(
			host: host,
			path: path,
			filter: filter,
			value: value,
			encoder: encoder,
			idToken: idToken
		)
	}

}
