import UIKit

protocol MainViewControllerPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapDelete(at index: Int)
    func search(text: String)
    func didLoadTodos(_ todos: [Todo])
    func didFail(error: Error)
    
    func toggleTodoStatus(at index: Int)
    
}

final class MainViewControllerPresenter: MainViewControllerPresenterProtocol {
    
    weak var view: MainViewControllerProtocol?
    var interactor: TodoListInteractorProtocol?
    private var todos: [Todo] = []
    
    func viewDidLoad() {
        interactor?.loadTodos()
    }
    
    func didLoadTodos(_ todos: [Todo]) {
        self.todos = todos
        view?.showTodos(todos)
    }
    
    func didFail(error: Error) {
        view?.showError(error.localizedDescription)
    }
    
    func toggleTodoStatus(at index: Int) {
        guard index < todos.count else { return }
        todos[index].completed.toggle()
        view?.updateTodo(at: index, todo: todos[index])
    }
    
    func didTapDelete(at index: Int) {
        
    }
    
    func search(text: String) {
        
    }
}
