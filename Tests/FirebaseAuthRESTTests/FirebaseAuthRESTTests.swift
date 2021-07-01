import XCTest
import TestFoundation
@testable import FirebaseAuthREST

@available(macOS 12.0, iOS 15, *)
final class FirebaseAuthRESTTests: XCTestCase {

	let loginData = DatabaseLoginData.shared

	func testBasicAuthentication() async throws {
		let credentials = EmailCredentials(email: loginData.email, password: loginData.password)

		let session = FirebaseAuthSession(apiKey: loginData.apiKey)
		_ = try await session.signIn(with: credentials)
	}

	func testRefreshToken() async throws {
		let session = FirebaseAuthSession(apiKey: loginData.apiKey)
		_ = try await session.refreshToken(with: "AG8BCnclzcapetqjzabmw_8aCCKYq05-PubW_c3rqSwmWatR5VV584X0yN8GjI_ZGa0_2vOPB2o-bZOLiJAJhOip0WFoCUP47diGJJ7W0hZj8XhAI2Ru89SJNiie1Xyblw54XcZ5jD4irvAm2zTbEUzck9HEiw6w8qjoBW8vzJka0ZNIKRSBrHLf0Iuf4CaaLJfZYYEqvjzgnrCP-4DBN7DwKeJfhXPb8UM1wNM4sVW3zYrieG1exbE")
	}

	func testWrongPassword() async {
		let credentials = EmailCredentials(email: loginData.email, password: "some-very-wrong-password")

		let session = FirebaseAuthSession(apiKey: loginData.apiKey)
		do {
			_ = try await session.signIn(with: credentials)
		} catch let error as NSError {
			XCTAssertEqual(error.code, 400)
			XCTAssertEqual(error.localizedDescription, FirebaseAuthError.Reason.invalidPassword.errorMessage)
		}
	}

}

func XCTFailIfError(_ error: Error?) {
	guard let error = error else {
		return
	}
	XCTFail(error.localizedDescription)
}

struct User: Codable, Equatable {
	let name: String
	let group: String
}
