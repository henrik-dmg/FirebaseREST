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

	// MARK: - NetworkRequest

	public var httpBody: Data? {
		try? encodeToJSON()
	}

	public var requestMethod: NetworkRequestMethod {
		.patch
	}

	public var headerFields: [NetworkRequestHeaderField]? {
		[.contentTypeJSON]
	}

	public func makeURL() throws -> URL {
		try makeURL(with: .silent)
	}

	// MARK: - Init

	init(
		host: String,
		path: DatabasePath,
		filter: DatabaseQueryFilter?,
		value: E,
		encoder: JSONEncoder,
		idToken: String?
	) {
		self.host = host
		self.path = path
		self.filter = filter
		self.value = value
		self.encoder = encoder
		self.idToken = idToken
	}

	// MARK: - Helper

	private func encodeToJSON() throws -> Data {
		if #available(OSX 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
			encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
		} else {
			encoder.outputFormatting = [.prettyPrinted]
		}
		return try encoder.encode(value)
	}

	public func convertError(_ error: Error, data: Data?, response: URLResponse?) -> Error {
		guard let data = data else {
			return error
		}

		do {
			let error = try JSONDecoder().decode(SavingError.self, from: data)
			return NSError(description: error.error)
		} catch {
			return error
		}
	}

}
