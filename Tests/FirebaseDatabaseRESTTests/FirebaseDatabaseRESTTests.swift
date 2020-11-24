import XCTest
@testable import FirebaseDatabaseREST

final class FirebaseDatabaseRESTTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FirebaseDatabaseREST().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
