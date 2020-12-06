import Foundation
import HPNetwork

// https://firebase.google.com/docs/reference/rest/auth/#section-create-email-password

struct EmailSignUpRequest: FirebaseAuthRequest {

	typealias Output = EmailAuthResponse

	let apiKey: String
	let payload: EmailCredentials
	let finishingQueue: DispatchQueue

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
		try? JSONEncoder().encode(payload)
	}

}
