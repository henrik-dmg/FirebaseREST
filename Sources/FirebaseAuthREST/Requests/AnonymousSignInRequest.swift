import HPNetwork
import Foundation

// https://firebase.google.com/docs/reference/rest/auth/#section-sign-in-anonymously

struct AnonymousSignInRequest: FirebaseAuthRequest {

	typealias Output = EmailAuthResponse

	struct Payload {
		let returnSecureToken = true
	}

	let apiKey: String

	var url: URL? {
		URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=\(apiKey)")
	}

	var requestMethod: NetworkRequestMethod {
		.post
	}

	var headerFields: [NetworkRequestHeaderField]? {
		[.json]
	}

	var httpBody: Data? {
		"{\"returnSecureToken\":true}".data(using: .utf8)
	}

}
