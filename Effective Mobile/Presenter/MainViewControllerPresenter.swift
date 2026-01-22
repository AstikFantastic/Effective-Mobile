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
    
    func toggleTodoStatus(at index: Int) {
        guard index < searchedTodos.count else { return }
        let id = searchedTodos[index].id
        if let realIndex = todos.firstIndex(where: {$0.id == id}) {
            todos[realIndex].completed.toggle()
        }
        searchedTodos[index].completed.toggle()
        view?.updateTodo(at: index, todo: todos[index])
    }
    
    func didTapDelete(at index: Int) {
        
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
