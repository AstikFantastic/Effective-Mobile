import Foundation

struct EmbeddedModel: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}

struct Todo: Codable {
    let id: Int
    let todo: String
    var completed: Bool
    var date: Date?

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
    }
}
