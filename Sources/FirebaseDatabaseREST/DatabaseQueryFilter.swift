import Foundation

public struct DatabaseQueryFilter {

	public enum Mode {
		case limitToFirst(_ value: JSONPrimitive)
		case limitToLast(_ value: JSONPrimitive)
		case startAt(_ value: JSONPrimitive)
		case endAt(_ value: JSONPrimitive)
		case equalTo(_ value: JSONPrimitive)

		var filterName: String {
			switch self {
			case .limitToFirst:
				return "limitToFirst"
			case .limitToLast:
				return "limitToLast"
			case .startAt:
				return "startAt"
			case .endAt:
				return "endAt"
			case .equalTo:
				return "equalTo"
			}
		}

		var value: JSONPrimitive {
			switch self {
			case .limitToLast(let value), .limitToFirst(let value), .startAt(let value), .endAt(let value), .equalTo(let value):
				return value
			}
		}
	}

	private let childKey: String
	private let filterModes: [Mode]

	public init(childKey: String, filterMode: DatabaseQueryFilter.Mode) {
		self.childKey = childKey
		self.filterModes = [filterMode]
	}

	public init(childKey: String, filterModes: [DatabaseQueryFilter.Mode]) {
		self.childKey = childKey
		self.filterModes = filterModes
	}

	func generateQueryItems() -> [URLQueryItem] {
		var items = [URLQueryItem(name: "orderBy", value: "\"\(childKey)\""),]

		for mode in filterModes {
			items.append(URLQueryItem(name: mode.filterName, value: mode.value.queryRepresentation))
		}

		return items
	}

}
