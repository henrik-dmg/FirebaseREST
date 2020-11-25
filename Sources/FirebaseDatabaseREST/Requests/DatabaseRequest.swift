import HPNetwork
import Foundation

protocol DatabaseRequest: NetworkRequest {

	var host: String { get }
	var pathComponents: [String] { get }
	var idToken: String? { get }

}

protocol NoResponeRequest: DatabaseRequest {

	init(host: String, pathComponents: [String], idToken: String?)
	
}

enum PrintMode: String {
	case silent, pretty
}

extension DatabaseRequest {

	func makeURL(with printMode: PrintMode) -> URL? {
		guard !pathComponents.isEmpty else {
			return nil
		}
		let pathString = pathComponents.joined(separator: "/") + ".json"

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
