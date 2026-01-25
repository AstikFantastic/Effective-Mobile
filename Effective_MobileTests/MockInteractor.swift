@testable import Effective_Mobile
import Foundation

final class MockInteractor: TodoListInteractorProtocol {

    var loadCalled = false

    func loadTodos() {
        loadCalled = true
    }

    func updateTodoCompleted(id: Int, complited: Bool) {}

    func deleteTodo(id: Int) {}

    func updateTodoInformation(id: Int, title: String, desctiption: String, date: Date?) {}

    func createTodo(title: String, description: String, date: Date?) {}
}
