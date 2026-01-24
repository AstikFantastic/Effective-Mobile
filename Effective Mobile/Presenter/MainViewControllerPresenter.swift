import UIKit

protocol MainViewControllerPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapDelete(at index: Int)
    func didTapShare()
    func didTapEdit()
    func search(text: String)
    func didLoadTodos(_ todos: [Todo])
    func didFail(error: Error)
    func toggleTodoStatus(todoID: Int)
}

final class MainViewControllerPresenter: MainViewControllerPresenterProtocol {
    
    
    weak var view: MainViewControllerProtocol?
    var interactor: TodoListInteractorProtocol?
    private var todos: [Todo] = []
    private var searchedTodos: [Todo] = []
    
    func viewDidLoad() {
        interactor?.loadTodos()
    }
    
    func didLoadTodos(_ todos: [Todo]) {
        self.todos = todos
        searchedTodos = todos
        view?.showTodos(todos)
    }
    
    func didFail(error: Error) {
        view?.showError(error.localizedDescription)
    }
    
    func toggleTodoStatus(todoID: Int) {
        guard let indexInAll = todos.firstIndex(where: { $0.id == todoID }) else { return }
        todos[indexInAll].completed.toggle()
        let newValue = todos[indexInAll].completed
        
        CoreDataService.shared.updateTodo(id: todoID, completed: newValue)
        
        if let indexInVisible = searchedTodos.firstIndex(where: { $0.id == todoID }) {
            searchedTodos[indexInVisible].completed.toggle()
            view?.updateTodo(at: indexInVisible, todo: searchedTodos[indexInVisible])
        }
    }
        
    func didTapDelete(at index: Int) {
        
    }
    
    func didTapShare() {
        
    }
    
    func didTapEdit() {
        
    }
    
    func search(text: String) {
        guard !text.isEmpty else {
            searchedTodos = todos
            view?.showTodos(todos)
            return
        }
        searchedTodos = todos.filter {
            $0.todo.lowercased().contains(text.lowercased())
        }
        view?.showTodos(searchedTodos)
    }
}
