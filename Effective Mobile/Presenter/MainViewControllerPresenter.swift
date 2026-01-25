import UIKit

protocol MainViewControllerPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapDelete(at index: Int)
    func didTapShare(_ todo: Todo)
    func search(text: String)
    func didLoadTodos(_ todos: [Todo])
    func didFail(error: Error)
    func toggleTodoStatus(todoID: Int)
    func didSelectEditTodo(_ todo: Todo)
}

final class MainViewControllerPresenter: MainViewControllerPresenterProtocol {
    weak var view: MainViewControllerProtocol?
    var interactor: TodoListInteractorProtocol?
    var router: UsersRouterProtocol?
    private var todos: [Todo] = []
    private var searchedTodos: [Todo] = []
    
    func viewDidLoad() {
        interactor?.loadTodos()
    }
    
    func didLoadTodos(_ todos: [Todo]) {
        self.todos = todos
        searchedTodos = todos
        view?.showTodos(todos)
        view?.showTotalCount(todos.count)
    }
    
    func didFail(error: Error) {
        view?.showError(error.localizedDescription)
    }
    
    func toggleTodoStatus(todoID: Int) {
        guard let indexInAll = todos.firstIndex(where: { $0.id == todoID }) else { return }
        todos[indexInAll].completed.toggle()
        let newValue = todos[indexInAll].completed
        interactor?.updateTodoCompleted(id: todoID, complited: newValue)
        if let indexInVisible = searchedTodos.firstIndex(where: { $0.id == todoID }) {
            searchedTodos[indexInVisible].completed.toggle()
            view?.updateTodo(at: indexInVisible, todo: searchedTodos[indexInVisible])
        }
    }
    
    func didTapDelete(at index: Int) {
        let todo = searchedTodos[index]
        interactor?.deleteTodo(id: todo.id)
        searchedTodos.remove(at: index)
        todos.removeAll { $0.id == todo.id }
        view?.deleteRow(at: index, updatedTodos: searchedTodos)
        view?.showTotalCount(todos.count)
    }

    func didTapShare(_ todo: Todo) {
        let title = todo.title ?? "Task № \(todo.id)"
        let description = todo.todo
        let status = todo.completed ? "Completed" : "Not Complited"
        let dateText: String
        if let date = todo.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            dateText = formatter.string(from: date)
        } else {
            dateText = "Date not selected"
        }
        let text = """
            Task: \(title)
            Description: \(description)
            Date: \(dateText)
            Status: \(status)
            """
        
        router?.openShare(text: text)
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
    
    func didSelectEditTodo(_ todo: Todo) {
        let updatedTodos = CoreDataService.shared.fetchTodos()
        guard let freshTodo = updatedTodos.first(where: { $0.id == todo.id }) else {
            router?.openEditTodo(todo: todo)
            return
        }
        router?.openEditTodo(todo: freshTodo)
    }
}
