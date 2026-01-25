import UIKit

protocol UsersRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func openEditTodo(todo: Todo)
    func openShare(text: String)
}

final class UserRouter: UsersRouterProtocol {
    
    weak var navigationController: UINavigationController?
    weak var interactor: TodoListInteractorProtocol?
    
    static func createModule() -> UIViewController {
        let view = MainViewController()
        let presenter = MainViewControllerPresenter()
        let interactor = ToDoInteractor()
        let router = UserRouter()
        let nav = UINavigationController(rootViewController: view)
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.router = router
        router.interactor = interactor
        router.navigationController = nav
        
        return nav
    }
    
    func openEditTodo(todo: Todo) {
        let editVC = EditTodoViewController(todo: todo)
        editVC.interactor = interactor
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func openShare(text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        navigationController?.present(activityVC, animated: true)
    }
}
