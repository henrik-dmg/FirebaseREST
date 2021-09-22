import Foundation
import HPNetwork

protocol FirebaseAuthRequest: DecodableRequest {}

extension FirebaseAuthRequest {

	func convertError(error: URLError, data: Data, response: URLResponse) -> Error {
		if let authError = try? JSONDecoder().decode(FirebaseAuthError.self, from: data) {
			return authError.nsError
		} else {
			return error
		}
	}

}
