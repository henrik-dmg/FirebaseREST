import Foundation
import HPNetwork

public struct UpdateRequest<E: Encodable>: DatabaseRequest {

	public typealias Output = Data

	// MARK: - Properties

	let value: E
	let host: String
	let path: DatabasePath
	let filter: DatabaseQueryFilter?
	let encoder: JSONEncoder
	let idToken: String?
	public let finishingQueue: DispatchQueue

	// MARK: - NetworkRequest

	public var url: URL? {
		makeURL(with: .silent)
	}

	public var httpBody: Data? {
		try? encodeToJSON()
	}

	public var requestMethod: NetworkRequestMethod {
		.patch
	}

	public var headerFields: [NetworkRequestHeaderField]? {
		[NetworkRequestHeaderField.json]
	}

	// MARK: - Init

	init(
		host: String,
		path: DatabasePath,
		filter: DatabaseQueryFilter?,
		value: E,
		encoder: JSONEncoder,
		idToken: String?,
		finishingQueue: DispatchQueue
	) {
		self.host = host
		self.path = path
		self.filter = filter
		self.value = value
		self.encoder = encoder
		self.idToken = idToken
		self.finishingQueue = finishingQueue
	}

	// MARK: - Helper

	private func encodeToJSON() throws -> Data {
		encoder.outputFormatting = .prettyPrinted
		return try encoder.encode(value)
	}

}