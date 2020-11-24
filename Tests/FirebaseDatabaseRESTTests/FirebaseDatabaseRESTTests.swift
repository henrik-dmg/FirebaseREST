import XCTest
@testable import FirebaseDatabaseREST

final class FirebaseDatabaseRESTTests: XCTestCase {

	func testBasicWrite() {
		let expectation = XCTestExpectation(description: "Networking finished")

		let ref = DatabaseReference(host: "musicmatcher-59bc0.firebaseio.com")
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

		let ref = DatabaseReference(host: "musicmatcher-59bc0.firebaseio.com")
			.child("users")
			.child("admin")

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
