import Foundation
import HPNetwork

public protocol DatabaseQuery {

	associatedtype Request: NetworkRequest

	var path: DatabasePath { get }
	var filter: DatabaseQueryFilter? { get }

	func makeNetworkRequest(host: String, idToken: String?, finishingQueue: DispatchQueue) -> Request

}
