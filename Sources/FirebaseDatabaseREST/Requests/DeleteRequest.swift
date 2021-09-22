import Foundation
import HPNetwork

public struct DeleteRequest: DatabaseRequest {

	public typealias Output = Data

	let host: String
	let path: DatabasePath
	let filter: DatabaseQueryFilter?
	let idToken: String?

	public var requestMethod: NetworkRequestMethod {
		.delete
	}

	init(host: String, path: DatabasePath, filter: DatabaseQueryFilter?, idToken: String?) {
		self.host = host
		self.path = path
		self.filter = filter
		self.idToken = idToken
	}

	public func makeURL() throws -> URL {
		try makeURL(with: .silent)
	}

}
