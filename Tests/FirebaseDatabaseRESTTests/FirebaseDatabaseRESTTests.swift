import XCTest
import FirebaseAuthREST
@testable import FirebaseDatabaseREST

final class FirebaseDatabaseRESTTests: XCTestCase {

	var _serviceAccount: ServiceAccount?

	override func setUpWithError() throws {
		guard let configURL = Bundle.module.url(forResource: "Service_Account", withExtension: "json") else {
			throw NSError(description: "Service account json not found")
		}
		let data = try Data(contentsOf: configURL)
		_serviceAccount = try JSONDecoder().decode(ServiceAccount.self, from: data)
	}

	func testBasicWrite() {
		let expectation = XCTestExpectation(description: "Networking finished")

		let credentials = EmailSignInCredentials(email: "musicmatcher@panhans.dev", password: "hmkNMCo4JdFE@6FT.Rro8uiiMyP.PZZgnKXA.wxn6Dpi")
		let ref = DatabaseReference(host: "musicmatcher-59bc0.firebaseio.com", apiKey: "AIzaSyCPGNY-cA_jrTWeadvK5jUBVuBC0EHn-ZA", emailCredentials: credentials)
			.child("users")
			.child("admin")
		let user = User(name: "admin", group: "moreAdmin")

		ref.saveObject(user) { error in
			XCTFailIfError(error)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10)
	}

	func testBasicDeletion() {
		let expectation = XCTestExpectation(description: "Networking finished")

		let credentials = EmailSignInCredentials(email: "musicmatcher@panhans.dev", password: "hmkNMCo4JdFE@6FT.Rro8uiiMyP.PZZgnKXA.wxn6Dpi")
		let ref = DatabaseReference(host: "musicmatcher-59bc0.firebaseio.com", apiKey: "AIzaSyCPGNY-cA_jrTWeadvK5jUBVuBC0EHn-ZA", emailCredentials: credentials)
			.child("users")
			.child("admin")
		let user = User(name: "admin", group: "moreAdmin")

		ref.deleteObject() { error in
			XCTFailIfError(error)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10)
	}

	func testBasicGet() {
		let expectation = XCTestExpectation(description: "Networking finished")

		let ref = DatabaseReference(host: "musicmatcher-59bc0.firebaseio.com")
			.child("users")
			.child("admin")
		let initialUser = User(name: "admin", group: "moreAdmin")

		ref.retrieveObject(resultType: User.self) { result in
			switch result {
			case .success(let user):
				XCTAssertEqual(user, initialUser)
			case .failure(let error):
				XCTFail(error.localizedDescription)
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
