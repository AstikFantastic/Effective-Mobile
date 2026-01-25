import UIKit

protocol UsersRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func openEditTodo(todo: Todo)
}

final class UserRouter: UsersRouterProtocol {
    
    weak var interactor: TodoListInteractorProtocol?
    
    static func createModule() -> UIViewController {
        let view = MainViewController()
        let presenter = MainViewControllerPresenter()
        let interactor = ToDoInteractor()
        let router = UserRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.router = router
        router.interactor = interactor
        
        return view
    }
    
    func openEditTodo(todo: Todo) {
        let editVC = EditTodoViewController(todo: todo)
        editVC.interactor = interactor
        guard let topVC = UIApplication.shared.windows.first?.rootViewController else { return }
        if let nav = topVC as? UINavigationController {
            nav.pushViewController(editVC, animated: true)
        } else {
            topVC.navigationController?.pushViewController(editVC, animated: true)
        }
    }
    
    
}
