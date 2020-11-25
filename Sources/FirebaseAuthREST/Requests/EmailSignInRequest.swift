import HPNetwork
import Foundation

public struct EmailSignInCredentials: Encodable {

	public let email: String
	public let password: String
	private let returnSecureToken = true

	public init(email: String, password: String) {
		self.email = email
		self.password = password
	}

}

struct EmailSignInRequest: NetworkRequest {

	typealias Output = TokenInformation

	let apiKey: String
	let payload: EmailSignInCredentials

	var url: URL? {
		URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=\(apiKey)")
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

	func convertResponse(response: NetworkResponse) throws -> TokenInformation {
		try JSONDecoder().decode(FirebaseAuthResponse.self, from: response.data)
	}

}

extension Data {
	var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
		guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
			  let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
			  let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

		return prettyPrintedString
	}
}
