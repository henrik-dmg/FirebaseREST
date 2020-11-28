import Foundation

public struct DatabaseQueryFilter {

	public enum Mode {
		case limitToFirst(_ value: CustomStringConvertible)
		case limitToLast(_ value: CustomStringConvertible)
		case startAt(_ value: CustomStringConvertible)
		case endAt(_ value: CustomStringConvertible)
		case equalTo(_ value: CustomStringConvertible)
	}

	let childKey: String
	let mode: Mode

	public init(childKey: String, mode: DatabaseQueryFilter.Mode) {
		self.childKey = childKey
		self.mode = mode
	}

	func generateQueryItems() -> [URLQueryItem] {
		var items = [URLQueryItem(name: "orderBy", value: childKey),]

		switch mode {
		case .limitToFirst(let value):
			items.append(URLQueryItem(name: "limitToFirst", value: value.description))
		case .limitToLast(let value):
			items.append(URLQueryItem(name: "limitToLast", value: value.description))
		case .startAt(let value):
			items.append(URLQueryItem(name: "startAt", value: value.description))
		case .endAt(let value):
			items.append(URLQueryItem(name: "endAt", value: value.description))
		case .equalTo(let value):
			items.append(URLQueryItem(name: "equalTo", value: value.description))
		}

		return items
	}

}
