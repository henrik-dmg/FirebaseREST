import Foundation

public struct DatabaseLoginData {

	public static var shared: DatabaseLoginData {
		guard
			let email = ProcessInfo.processInfo.environment["DATABASE_EMAIL"],
			let password = ProcessInfo.processInfo.environment["DATABASE_PASSWORD"],
			let apiKey = ProcessInfo.processInfo.environment["FIREBASE_API_KEY"],
			let host = ProcessInfo.processInfo.environment["DATABASE_HOST"]
		else {
			preconditionFailure("Did not set environment variables from secrets")
		}

		return DatabaseLoginData(email: email, password: password, apiKey: apiKey, host: host)
	}

	public let email: String
	public let password: String
	public let apiKey: String
	public let host: String

}
