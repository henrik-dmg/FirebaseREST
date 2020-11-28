import Foundation

public struct DatabasePath {

	let components: [String]

	internal init(components: [String]) {
		self.components = components
	}

	public func child(_ path: String) -> DatabasePath {
		let encodedString = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
		return DatabasePath(components: components + [encodedString ?? path])
	}

	func makeEscapedPath() -> String {
		components.joined(separator: "/")
	}

}
