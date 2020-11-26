import Foundation
import HPNetwork

protocol FirebaseAuthRequest: NetworkRequest {}

extension FirebaseAuthRequest where Output: Decodable {

	func convertError(_ error: Error, data: Data?, response: URLResponse?) -> Error {
		guard let data = data else {
			return error
		}

		if let authError = try? JSONDecoder().decode(FirebaseAuthError.self, from: data) {
			return authError.nsError
		} else {
			return error
		}
	}

}
