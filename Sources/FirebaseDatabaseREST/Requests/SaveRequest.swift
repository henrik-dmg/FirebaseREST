import Foundation
import HPNetwork

struct SaveRequest<E: Encodable>: DatabaseRequest {

	typealias Output = Data

	// MARK: - Properties

	let host: String
	let pathComponents: [String]
	let value: E
	let isUpdate: Bool
	let encoder: JSONEncoder
	let idToken: String?

	// MARK: - NetworkRequest

	var url: URL? {
		makeURL(with: .silent)
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

	init(
		host: String,
		pathComponents: [String],
		value: E,
		isUpdate: Bool,
		encoder: JSONEncoder,
		idToken: String?
	) {
		self.host = host
		self.pathComponents = pathComponents
		self.value = value
		self.isUpdate = isUpdate
		self.encoder = encoder
		self.idToken = idToken
	}

	// MARK: - Helper

	func encodeToJSON() throws -> Data {
		encoder.outputFormatting = .prettyPrinted
		return try encoder.encode(value)
	}

}
