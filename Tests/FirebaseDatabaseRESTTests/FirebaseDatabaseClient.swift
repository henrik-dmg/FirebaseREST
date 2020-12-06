import XCTest
import FirebaseAuthREST
import TestFoundation
@testable import FirebaseDatabaseREST

final class FirebaseDatabaseClientTests: XCTestCase {

	let loginData = DatabaseLoginData.shared

	func testBasicAWrite() {
		let expectation = XCTestExpectation(description: "Networking finished")

		let credentials = EmailCredentials(email: loginData.email, password: loginData.password)
		let database = FirebaseDatabaseClient(host: loginData.host, apiKey: loginData.apiKey, emailCredentials: credentials)
		let path = database.path().child("users")
		let user = User(name: "admin", group: "moreAdmin")
		let user2 = User(name: "henrik", group: "moreAdmin")

		let saveQuery = SaveQuery(value: [user, user2], path: path)

		database.performQuery(saveQuery) { result in
			XCTFailIfError(result)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10)
	}

	func testBasicBGet() {
		let expectation = XCTestExpectation(description: "Networking finished")

		let credentials = EmailCredentials(email: loginData.email, password: loginData.password)
		let database = FirebaseDatabaseClient(host: loginData.host, apiKey: loginData.apiKey, emailCredentials: credentials)
		let path = database.path().child("users")
		let initialUser = User(name: "admin", group: "moreAdmin")
		let initialUser2 = User(name: "henrik", group: "moreAdmin")

		let retrieveQuery = RetrieveQuery<[User]>(path: path, filter: nil)

		database.performQuery(retrieveQuery) { result in
			switch result {
			case .success(let users):
				XCTAssertEqual(users, [initialUser, initialUser2])
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
	}

	func testBasicCDeletion() {
		let expectation = XCTestExpectation(description: "Networking finished")

		let credentials = EmailCredentials(email: loginData.email, password: loginData.password)
		let database = FirebaseDatabaseClient(host: loginData.host, apiKey: loginData.apiKey, emailCredentials: credentials)
		let path = database.path().child("users")

		let deleteQuery = DeleteQuery(path: path)

		database.performQuery(deleteQuery) { error in
			XCTFailIfError(error)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10)
	}

	func testBasicDWriteQueue() {
		let queue = DispatchQueue(label: "com.henrikpanhans.TestQueue")

		let expectation = XCTestExpectation(description: "Networking finished")

		let credentials = EmailCredentials(email: loginData.email, password: loginData.password)
		let database = FirebaseDatabaseClient(host: loginData.host, apiKey: loginData.apiKey, emailCredentials: credentials, finishingQueue: queue)
		let path = database.path().child("users")
		let user = User(name: "admin", group: "moreAdmin")
		let user2 = User(name: "henrik", group: "moreAdmin")

		let saveQuery = SaveQuery(value: [user, user2], path: path)

		database.performQuery(saveQuery) { result in
			XCTAssertFalse(Thread.current.isMainThread)
			XCTFailIfError(result)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10)
	}

	func testFilterEGet() {
		let expectation = XCTestExpectation(description: "Networking finished")

		let credentials = EmailCredentials(email: loginData.email, password: loginData.password)
		let database = FirebaseDatabaseClient(host: loginData.host, apiKey: loginData.apiKey, emailCredentials: credentials)
		let path = database.path().child("users")
		let initialUser = User(name: "admin", group: "moreAdmin")

		let retrieveQuery = RetrieveQuery<[String: User]>(path: path, filter: DatabaseQueryFilter(childKey: "name", filterMode: .equalTo("admin")))

		database.performQuery(retrieveQuery) { result in
			switch result {
			case .success(let data):
				XCTAssertEqual(data["0"], initialUser)
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 10)
	}

}

func XCTFailIfError<Success, Failure>(_ result: Result<Success, Failure>) {
	if case .failure(let error) = result {
		XCTFail(error.localizedDescription)
	}
}

struct User: Codable, Equatable {
	let name: String
	let group: String
}
