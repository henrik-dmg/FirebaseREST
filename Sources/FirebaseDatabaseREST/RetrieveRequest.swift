import Foundation
import HPNetwork

final class RetrieveRequest<D: Decodable>: DecodableRequest<D> {

	typealias Output = D

	let host: String
	let pathComponents: [String]
	let _decoder: JSONDecoder

	override var url: URL? {
		guard !pathComponents.isEmpty else {
			return nil
		}
		let pathString = pathComponents.joined(separator: "/") + ".json"

		return URLQueryItemsBuilder(host: host)
			.addingPathComponent(pathString)
			.addingQueryItem("pretty", name: "print")
			.build()
	}

	override var decoder: JSONDecoder {
		_decoder
	}

	init(host: String, pathComponents: [String], decoder: JSONDecoder, finishingQueue: DispatchQueue) {
		self.host = host
		self.pathComponents = pathComponents
		self._decoder = decoder
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
