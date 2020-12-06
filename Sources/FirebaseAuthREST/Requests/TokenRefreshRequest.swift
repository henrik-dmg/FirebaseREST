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
	let finishingQueue: DispatchQueue

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

}

