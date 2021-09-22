import HPNetwork
import HPURLBuilder
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
			throw NSError(code: 6, description: "Path components are empty")
		}
		let pathString = path.makeEscapedPath() + ".json"

		return try URL.buildThrowing {
			Host(host)
			PathComponent(pathString)
			QueryItem(name: "print", value: printMode.rawValue)

			ForEach(filter?.generateQueryItems()) {
				QueryItem(name: $0.name, value: $0.value)
			}

			QueryItem(name: "auth", value: idToken)
		}
	}

}
