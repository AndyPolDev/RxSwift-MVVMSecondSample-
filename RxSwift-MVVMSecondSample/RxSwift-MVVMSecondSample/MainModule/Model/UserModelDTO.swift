import Foundation

struct UserModelDTO: Codable {
	let userID: Int
	let id: Int
	var title: String
	let body: String

	enum CodingKeys: String, CodingKey {
		case userID = "userId"
		case id, title, body
	}
}
