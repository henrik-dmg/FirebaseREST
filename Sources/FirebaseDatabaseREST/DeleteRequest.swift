import Foundation
import HPNetwork

struct DeleteRequest: NetworkRequest {

	typealias Output = Data

	let host: String
	let pathComponents: [String]
	let finishingQueue: DispatchQueue

	var url: URL? {
		guard !pathComponents.isEmpty else {
			return nil
		}
		let pathString = pathComponents.joined(separator: "/") + ".json"

		return URLQueryItemsBuilder(host: host)
			.addingPathComponent(pathString)
			.addingQueryItem("silent", name: "print")
			.build()
	}

	var requestMethod: NetworkRequestMethod {
		.delete
	}

	init(host: String, pathComponents: [String], finishingQueue: DispatchQueue) {
		self.host = host
		self.pathComponents = pathComponents
		self.finishingQueue = finishingQueue
	}

}
