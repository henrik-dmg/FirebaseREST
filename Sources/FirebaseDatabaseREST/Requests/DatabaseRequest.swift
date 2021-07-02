import HPNetwork
import Foundation

protocol DatabaseRequest: DataRequest {

	var host: String { get }
	var path: DatabasePath { get }
	var filter: DatabaseQueryFilter? { get }
	var idToken: String? { get }

}

enum PrintMode: String {
	case silent, pretty
}

extension DatabaseRequest {

	func makeURL(with printMode: PrintMode) throws -> URL {
		guard !path.components.isEmpty else {
			throw NSError.unknown
		}
		let pathString = path.makeEscapedPath() + ".json"

		var builder = URLBuilder(host: host)
			.addingPathComponent(pathString)
			.addingQueryItem(name: "print", value: printMode.rawValue)

		filter.flatMap { $0 }?.generateQueryItems().forEach {
			builder = builder.addingQueryItem(name: $0.name, value: $0.value)
		}

		if let token = idToken {
			return try builder.addingQueryItem(name: "auth", value: token).buildThrowing()
		} else {
			return try builder.buildThrowing()
		}
	}

}
