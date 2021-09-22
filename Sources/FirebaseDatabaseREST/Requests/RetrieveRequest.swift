import Foundation
import HPNetwork

public struct RetrieveRequest<D: Decodable>: DatabaseRequest {

	public typealias Output = D

	let host: String
	let path: DatabasePath
	let filter: DatabaseQueryFilter?
	let decoder: JSONDecoder
	let idToken: String?
	public let requestMethod = NetworkRequestMethod.get

	init(
		host: String,
		path: DatabasePath,
		filter: DatabaseQueryFilter?,
		decoder: JSONDecoder,
		idToken: String?
	) {
		self.host = host
		self.path = path
		self.filter = filter
		self.decoder = decoder
		self.idToken = idToken
	}

	public func convertResponse(data: Data, response: URLResponse) throws -> D {
		try validateBytes(data)
		return try decoder.decode(D.self, from: data)
	}

	private func validateBytes(_ data: Data) throws {
		let nullSequenceBytes: [UInt8] = [
			110,
			117,
			108,
			108,
			10
		]

		guard data.count == nullSequenceBytes.count else {
			return
		}

		try nullSequenceBytes.enumerated().forEach { element in
			if data[element.offset] == element.element {
				throw NSError(code: 69, description: "The returned data was empty")
			}
		}
	}

	public func makeURL() throws -> URL {
		try makeURL(with: .pretty)
	}

}
