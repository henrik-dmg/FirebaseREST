import Foundation
import HPNetwork

// https://firebase.google.com/docs/reference/rest/auth/#section-create-email-password

struct EmailSignUpRequest: FirebaseAuthRequest {

	typealias Output = EmailAuthResponse

	let apiKey: String
	let payload: EmailCredentials

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
		try? JSONEncoder().encode(payload)
	}

	func makeURL() throws -> URL {
		URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=\(apiKey)")!
	}

}
