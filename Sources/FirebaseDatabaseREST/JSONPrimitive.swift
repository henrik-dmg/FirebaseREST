import Foundation

public protocol JSONPrimitive {

	var queryRepresentation: String { get }

}

extension String: JSONPrimitive {
	public var queryRepresentation: String { "\"\(self)\"" }
}

extension LosslessStringConvertible {
	public var queryRepresentation: String { description }
}

extension Bool: JSONPrimitive {}

extension Int: JSONPrimitive {}
extension Int64: JSONPrimitive {}
extension Int32: JSONPrimitive {}
extension Int16: JSONPrimitive {}
extension Int8: JSONPrimitive {}
extension UInt: JSONPrimitive {}
extension UInt64: JSONPrimitive {}
extension UInt32: JSONPrimitive {}
extension UInt16: JSONPrimitive {}
extension UInt8: JSONPrimitive {}

extension Double: JSONPrimitive {}
extension Float: JSONPrimitive {}
extension CGFloat: JSONPrimitive {
	public var queryRepresentation: String { native.queryRepresentation }
}
