import UIKit
@testable import Effective_Mobile

final class MockRouter: UsersRouterProtocol {

    static func createModule() -> UIViewController {
        fatalError("Not needed for tests")
    }

    var openedEditTodo: Todo?
    var openedShareText: String?

    func openEditTodo(todo: Todo) {
        openedEditTodo = todo
    }

    func openShare(text: String) {
        openedShareText = text
    }

    func openCreateTodo() {}
}
