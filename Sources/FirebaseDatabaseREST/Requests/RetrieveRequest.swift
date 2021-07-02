import Foundation
import HPNetwork

public struct RetrieveRequest<D: Decodable>: DatabaseRequest {

	public typealias Output = D

	let host: String
	let path: DatabasePath
	let filter: DatabaseQueryFilter?
	let decoder: JSONDecoder
	let idToken: String?
	public let finishingQueue: DispatchQueue

	public func makeURL() throws -> URL {
		try makeURL(with: .silent)
	}

	public var requestMethod: NetworkRequestMethod {
		.get
	}

	init(
		host: String,
		path: DatabasePath,
		filter: DatabaseQueryFilter?,
		decoder: JSONDecoder,
		idToken: String?,
		finishingQueue: DispatchQueue
	) {
		self.host = host
		self.path = path
		self.filter = filter
		self.decoder = decoder
		self.idToken = idToken
		self.finishingQueue = finishingQueue
	}

	public func convertResponse(response: DataResponse) throws -> D {
		try validateBytes(response.data)
		return try decoder.decode(D.self, from: response.data)
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

}
