import HPNetwork
import Foundation

// https://firebase.google.com/docs/reference/rest/auth/#section-sign-in-anonymously

struct AnonymousSignInRequest: FirebaseAuthRequest {

	typealias Output = EmailAuthResponse

	struct Payload {
		let returnSecureToken = true
	}

	let apiKey: String

	func makeURL() throws -> URL {
		URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=\(apiKey)")!
	}

	var decoder: JSONDecoder {
		JSONDecoder()
	}

	var requestMethod: NetworkRequestMethod {
		.post
	}

	var headerFields: [NetworkRequestHeaderField]? {
		[.contentTypeJSON]
	}

	var httpBody: Data? {
		"{\"returnSecureToken\":true}".data(using: .utf8)
	}

}
