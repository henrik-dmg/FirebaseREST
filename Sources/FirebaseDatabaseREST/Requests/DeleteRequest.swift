import Foundation
import HPNetwork

struct DeleteRequest: DatabaseRequest {

	typealias Output = Data

	let host: String
	let pathComponents: [String]
	let idToken: String?

	var url: URL? {
		makeURL(with: .silent)
	}

	var requestMethod: NetworkRequestMethod {
		.delete
	}

	init(host: String, pathComponents: [String], idToken: String?) {
		self.host = host
		self.pathComponents = pathComponents
		self.idToken = idToken
	}

}
