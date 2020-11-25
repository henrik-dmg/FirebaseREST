import Foundation
import HPNetwork

final class RetrieveRequest<D: Decodable>: DecodableRequest<D>, DatabaseRequest {

	typealias Output = D

	let host: String
	let pathComponents: [String]
	let _decoder: JSONDecoder
	let idToken: String?

	override var url: URL? {
		makeURL(with: .pretty)
	}

	override var decoder: JSONDecoder {
		_decoder
	}

	init(host: String, pathComponents: [String], decoder: JSONDecoder, idToken: String?) {
		self.host = host
		self.pathComponents = pathComponents
		self._decoder = decoder
		self.idToken = idToken
		super.init(urlString: "")
	}

	override func convertResponse(response: NetworkResponse) throws -> Output {
		try validateBytes(response.data)
		return try super.convertResponse(response: response)
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
