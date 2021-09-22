import Foundation
import HPNetwork

public protocol DatabaseQuery {

	associatedtype Request: DataRequest

	var path: DatabasePath { get }
	var filter: DatabaseQueryFilter? { get }

	func makeNetworkRequest(host: String, idToken: String?) -> Request

}
