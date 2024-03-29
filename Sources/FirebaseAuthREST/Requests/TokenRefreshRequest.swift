import Foundation
import HPNetwork

// https://firebase.google.com/docs/reference/rest/auth/#section-refresh-token

struct TokenRefreshRequest: FirebaseAuthRequest {

	typealias Output = AuthTokenResponse

	struct Payload: Encodable {
		let refresh_token: String
		let grant_type = "refresh_token"
	}

	let apiKey: String
	let refreshToken: String

	var requestMethod: NetworkRequestMethod {
		.post
	}

	var decoder: JSONDecoder {
		JSONDecoder()
	}

	var headerFields: [NetworkRequestHeaderField]? {
		[.contentTypeJSON]
	}

	var httpBody: Data? {
		try? JSONEncoder().encode(Payload(refresh_token: refreshToken))
	}

	func makeURL() throws -> URL {
		URL(string: "https://securetoken.googleapis.com/v1/token?key=\(apiKey)")!
	}

}

