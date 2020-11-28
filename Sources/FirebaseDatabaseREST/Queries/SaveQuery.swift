import Foundation
import HPNetwork

public struct SaveQuery<E: Encodable>: DatabaseQuery {

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

extension SaveQuery {

	public func makeNetworkRequest(host: String, idToken: String?, finishingQueue: DispatchQueue) -> SaveRequest<E> {
		SaveRequest(
			host: host,
			path: path,
			filter: filter,
			value: value,
			encoder: encoder,
			idToken: idToken,
			finishingQueue: finishingQueue
		)
	}

}
