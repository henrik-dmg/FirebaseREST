import XCTest
import FirebaseAuthREST
import TestFoundation
@testable import FirebaseDatabaseREST

@available(macOS 12.0, iOS 15, *)
final class FirebaseDatabaseClientTests: XCTestCase {

	let loginData = DatabaseLoginData.shared

	func testBasicAWrite() async throws {
		let credentials = EmailCredentials(email: loginData.email, password: loginData.password)
		let database = FirebaseDatabaseClient(host: loginData.host, apiKey: loginData.apiKey, emailCredentials: credentials)
		let path = database.path().child("users")
		let user = User(name: "admin", group: "moreAdmin")
		let user2 = User(name: "henrik", group: "moreAdmin")

		let saveQuery = SaveQuery(value: [user, user2], path: path)

		_ = try await database.performQuery(saveQuery)
	}

	func testBasicBGet() async throws {
		let credentials = EmailCredentials(email: loginData.email, password: loginData.password)
		let database = FirebaseDatabaseClient(host: loginData.host, apiKey: loginData.apiKey, emailCredentials: credentials)
		let path = database.path().child("users")
		let initialUser = User(name: "admin", group: "moreAdmin")
		let initialUser2 = User(name: "henrik", group: "moreAdmin")

		let retrieveQuery = RetrieveQuery<[User]>(path: path, filter: nil)

		let users = try await database.performQuery(retrieveQuery)
		XCTAssertEqual(users, [initialUser, initialUser2])
	}

	func testBasicCDeletion() async throws {
		let credentials = EmailCredentials(email: loginData.email, password: loginData.password)
		let database = FirebaseDatabaseClient(host: loginData.host, apiKey: loginData.apiKey, emailCredentials: credentials)
		let path = database.path().child("users")

		let deleteQuery = DeleteQuery(path: path)

		_ = try await database.performQuery(deleteQuery)
	}

	func testBasicDWriteQueue() async throws {
		let credentials = EmailCredentials(email: loginData.email, password: loginData.password)
		let database = FirebaseDatabaseClient(host: loginData.host, apiKey: loginData.apiKey, emailCredentials: credentials)
		let path = database.path().child("users")
		let user = User(name: "admin", group: "moreAdmin")
		let user2 = User(name: "henrik", group: "moreAdmin")

		let saveQuery = SaveQuery(value: [user, user2], path: path)

		_ = try await database.performQuery(saveQuery)
	}

	func testFilterEGet() async throws {
		let credentials = EmailCredentials(email: loginData.email, password: loginData.password)
		let database = FirebaseDatabaseClient(host: loginData.host, apiKey: loginData.apiKey, emailCredentials: credentials)
		let path = database.path().child("users")
		let initialUser = User(name: "admin", group: "moreAdmin")

		let retrieveQuery = RetrieveQuery<[String: User]>(path: path, filter: DatabaseQueryFilter(childKey: "name", filterMode: .equalTo("admin")))

		let data = try await database.performQuery(retrieveQuery)
		XCTAssertEqual(data["0"], initialUser)
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
