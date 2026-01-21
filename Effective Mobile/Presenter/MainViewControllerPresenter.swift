import UIKit

protocol MainViewControllerPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapDelete(at index: Int)
    func search(text: String)
    func didLoadTodos(_ todos: [Todo])
    func didFail(error: Error)
    
}

final class MainViewControllerPresenter: MainViewControllerPresenterProtocol {

    weak var view: MainViewControllerProtocol?
    var interactor: TodoListInteractorProtocol?
    
    func viewDidLoad() {
        interactor?.loadTodos()
    }
    
    func didLoadTodos(_ todos: [Todo]) {
        view?.showTodos(todos)
    }
    
    func didFail(error: Error) {
        view?.showError(error.localizedDescription)
    }
    
    func didTapDelete(at index: Int) {
        
    }
    
    func search(text: String) {
        
    }
    
    
}
