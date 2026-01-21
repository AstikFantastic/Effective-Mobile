import UIKit

protocol UsersRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

final class UserRouter: UsersRouterProtocol {
    static func createModule() -> UIViewController {
        let view = MainViewController()
        let presenter = MainViewControllerPresenter()
        let interactor = ToDoInteractor()
        let router = UserRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    
}
