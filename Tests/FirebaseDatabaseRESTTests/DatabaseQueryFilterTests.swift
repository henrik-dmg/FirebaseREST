import XCTest
import FirebaseAuthREST
@testable import FirebaseDatabaseREST

final class DatabaseQueryFilterTests: XCTestCase {

	func testStringFilter() throws {
		let filter = DatabaseQueryFilter(childKey: "name", filterMode: .equalTo("John"))
		let query = RetrieveQuery<Int>(path: DatabasePath(components: ["users"]), filter: filter)
		let request = query.makeNetworkRequest(host: "google.com", idToken: nil, finishingQueue: .main)
		let url = try XCTUnwrap(request.makeURL(with: .silent))

		XCTAssertEqual(url.absoluteString, "https://google.com/users.json?print=silent&orderBy=%22name%22&equalTo=%22John%22")
	}

	func testIntFilter() throws {
		let filter = DatabaseQueryFilter(childKey: "height", filterMode: .equalTo(3))
		let query = RetrieveQuery<Int>(path: DatabasePath(components: ["users"]), filter: filter)
		let request = query.makeNetworkRequest(host: "google.com", idToken: nil, finishingQueue: .main)
		let url = try XCTUnwrap(request.makeURL(with: .silent))

		XCTAssertEqual(url.absoluteString, "https://google.com/users.json?print=silent&orderBy=%22height%22&equalTo=3")
	}

	func testDoubleFilter() throws {
		let filter = DatabaseQueryFilter(childKey: "name", filterMode: .equalTo(3.421))
		let query = RetrieveQuery<Int>(path: DatabasePath(components: ["users"]), filter: filter)
		let request = query.makeNetworkRequest(host: "google.com", idToken: nil, finishingQueue: .main)
		let url = try XCTUnwrap(request.makeURL(with: .silent))

		XCTAssertEqual(url.absoluteString, "https://google.com/users.json?print=silent&orderBy=%22name%22&equalTo=3.421")
	}
}
