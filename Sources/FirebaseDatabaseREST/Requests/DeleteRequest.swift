import Foundation
import HPNetwork

public struct DeleteRequest: DatabaseRequest {

	public typealias Output = Data

	let host: String
	let path: DatabasePath
	let filter: DatabaseQueryFilter?
	let idToken: String?

	public let finishingQueue: DispatchQueue

	public var url: URL? {
		makeURL(with: .silent)
	}

	public var requestMethod: NetworkRequestMethod {
		.delete
	}

	init(host: String, path: DatabasePath, filter: DatabaseQueryFilter?, idToken: String?, finishingQueue: DispatchQueue) {
		self.host = host
		self.path = path
		self.filter = filter
		self.idToken = idToken
		self.finishingQueue = finishingQueue
	}

}
