import Foundation

public struct DeleteQuery: DatabaseQuery {

	public typealias QueryOutput = Data

	public let path: DatabasePath
	public let filter: DatabaseQueryFilter?

	public init(path: DatabasePath) {
		self.path = path
		self.filter = nil
	}

}

extension DeleteQuery {

	public func makeNetworkRequest(host: String, idToken: String?) -> DeleteRequest {
		DeleteRequest(host: host, path: path, filter: filter, idToken: idToken)
	}

}
