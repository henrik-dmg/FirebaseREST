import HPNetwork
import Foundation

protocol DatabaseRequest: NetworkRequest {

	var host: String { get }
	var path: DatabasePath { get }
	var filter: DatabaseQueryFilter? { get }
	var idToken: String? { get }

}

enum PrintMode: String {
	case silent, pretty
}

extension DatabaseRequest {

	func makeURL(with printMode: PrintMode) -> URL? {
		guard !path.components.isEmpty else {
			return nil
		}
		let pathString = path.makeEscapedPath() + ".json"

		let builder = URLQueryItemsBuilder(host: host)
			.addingPathComponent(pathString)
			.addingQueryItem(printMode.rawValue, name: "print")

		if let token = idToken {
			return builder.addingQueryItem(token, name: "auth").build()
		} else {
			return builder.build()
		}
	}

}
