import Foundation
import HPNetwork

struct SaveRequest<E: Encodable>: NetworkRequest {

	// MARK: - Properties

	let host: String
	let pathComponents: [String]
	let value: E
	let isUpdate: Bool
	let encoder: JSONEncoder
	let finishingQueue: DispatchQueue

	// MARK: - NetworkRequest

	typealias Output = Data

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

	var httpBody: Data? {
		try? encodeToJSON()
	}

	var requestMethod: NetworkRequestMethod {
		isUpdate ? .patch : .put
	}

	var headerFields: [NetworkRequestHeaderField]? {
		[NetworkRequestHeaderField.json]
	}

	// MARK: - Init

	init(host: String, pathComponents: [String], value: E, isUpdate: Bool, encoder: JSONEncoder = .init(), finishingQueue: DispatchQueue = .main) {
		self.host = host
		self.pathComponents = pathComponents
		self.value = value
		self.isUpdate = isUpdate
		self.encoder = encoder
		self.finishingQueue = finishingQueue
	}

	// MARK: - Helper

	func encodeToJSON() throws -> Data {
		encoder.outputFormatting = .prettyPrinted
		return try encoder.encode(value)
	}

}
