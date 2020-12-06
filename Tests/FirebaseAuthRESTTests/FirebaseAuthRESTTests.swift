import XCTest
import TestFoundation
@testable import FirebaseAuthREST

final class FirebaseAuthRESTTests: XCTestCase {

	let loginData = DatabaseLoginData.shared

	func testBasicAuthentication() {
		let expectation = XCTestExpectation(description: "Networking finished")

		let credentials = EmailCredentials(email: loginData.email, password: loginData.password)

		let session = FirebaseAuthSession(apiKey: loginData.apiKey)
		session.signIn(with: credentials) { result in
			switch result {
			case .success:
				break
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10)
	}

	func testRefreshToken() {
		let expectation = XCTestExpectation(description: "Networking finished")

		let session = FirebaseAuthSession(apiKey: loginData.apiKey)
		session.refreshToken(with: "AG8BCnclzcapetqjzabmw_8aCCKYq05-PubW_c3rqSwmWatR5VV584X0yN8GjI_ZGa0_2vOPB2o-bZOLiJAJhOip0WFoCUP47diGJJ7W0hZj8XhAI2Ru89SJNiie1Xyblw54XcZ5jD4irvAm2zTbEUzck9HEiw6w8qjoBW8vzJka0ZNIKRSBrHLf0Iuf4CaaLJfZYYEqvjzgnrCP-4DBN7DwKeJfhXPb8UM1wNM4sVW3zYrieG1exbE") { result in
			switch result {
			case .success:
				break
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10)
	}

	func testWrongPassword() {
		let expectation = XCTestExpectation(description: "Networking finished")

		let credentials = EmailCredentials(email: loginData.email, password: "some-very-wrong-password")

		let session = FirebaseAuthSession(apiKey: loginData.apiKey)
		session.signIn(with: credentials) { result in
			switch result {
			case .success:
				XCTFail("We should not be able to log in with those credentials")
			case .failure(let error as NSError):
				XCTAssertEqual(error.code, 400)
				XCTAssertEqual(error.localizedDescription, FirebaseAuthError.Reason.invalidPassword.errorMessage)
			}
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10)
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
