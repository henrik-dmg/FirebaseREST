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
	let finishingQueue: DispatchQueue

	var url: URL? {
		URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=\(apiKey)")
	}

	var requestMethod: NetworkRequestMethod {
		.post
	}

	var headerFields: [NetworkRequestHeaderField]? {
		[.json]
	}

	var httpBody: Data? {
		try? JSONEncoder().encode(Payload(token: token))
	}

}
