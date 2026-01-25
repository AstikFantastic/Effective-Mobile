import UIKit
@testable import Effective_Mobile

final class MockMainView: MainViewControllerProtocol {

    var showedTodos: [Todo]?
    var showedCount: Int?
    var updatedTodo: Todo?
    var updatedIndex: Int?

    func showTodos(_ todos: [Todo]) {
        showedTodos = todos
    }

    func showError(_ message: String) {}

    func updateTodo(at index: Int, todo: Todo) {
        updatedIndex = index
        updatedTodo = todo
    }

    func showTotalCount(_ count: Int) {
        showedCount = count
    }
    
    func deleteRow(at index: Int, updatedTodos: [Effective_Mobile.Todo]) {
    }
}
