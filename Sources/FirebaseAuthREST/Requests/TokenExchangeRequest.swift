import Foundation
import HPNetwork

// https://firebase.google.com/docs/reference/rest/auth/#section-verify-custom-token

struct TokenExchangeRequest: FirebaseAuthRequest {

	typealias Output = FirebaseIDToken

	struct Payload: Encodable {
		let token: String
		let returnSecureToken = true
	}

	let apiKey: String
	let token: String

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
		try? JSONEncoder().encode(Payload(token: token))
	}

	func makeURL() throws -> URL {
		URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=\(apiKey)")!
	}

}
