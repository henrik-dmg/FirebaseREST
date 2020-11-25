import Foundation
import HPNetwork

struct TokenRefreshRequest: NetworkRequest {

	typealias Output = TokenInformation

	struct Payload: Encodable {
		let refresh_token: String
		let grant_type = "refresh_token"
	}

	let apiKey: String
	let refreshToken: String

	var url: URL? {
		URL(string: "https://securetoken.googleapis.com/v1/token?key=\(apiKey)")
	}

	var requestMethod: NetworkRequestMethod {
		.post
	}

	var headerFields: [NetworkRequestHeaderField]? {
		[.json]
	}

	var httpBody: Data? {
		try? JSONEncoder().encode(Payload(refresh_token: refreshToken))
	}

	func convertResponse(response: NetworkResponse) throws -> TokenInformation {
		try JSONDecoder().decode(FirebaseTokenResponse.self, from: response.data)
	}

}

