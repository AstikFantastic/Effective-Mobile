import XCTest
@testable import Effective_Mobile

final class MainPresenterTests: XCTestCase {
    var presenter: MainViewControllerPresenter!
    var view: MockMainView!
    var interactor: MockInteractor!
    var router: MockRouter!

    override func setUp() {
        super.setUp()

        presenter = MainViewControllerPresenter()
        view = MockMainView()
        interactor = MockInteractor()
        router = MockRouter()
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }

    func testViewDidLoadCallsInteractorLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(interactor.loadCalled, "Interactor.loadTodos()")
    }

    func testDidLoadTodosUpdatesViewAndCount() {
        let todos = [
            Todo(id: 1, title: nil, todo: "One", completed: false, date: nil),
            Todo(id: 2, title: "Test", todo: "Two", completed: true, date: nil)
        ]
        presenter.didLoadTodos(todos)
        XCTAssertEqual(view.showedTodos?.count, 2)
        XCTAssertEqual(view.showedCount, 2)
    }

    func testSearchFiltersByTitleAndDescription() {
        let todos = [
            Todo(id: 1, title: "Buy milk", todo: "From store", completed: false, date: nil),
            Todo(id: 2, title: nil, todo: "Meeting with John", completed: false, date: nil),
            Todo(id: 3, title: "Workout", todo: "Gym", completed: false, date: nil)
        ]
        presenter.didLoadTodos(todos)
        presenter.search(text: "buy")
        XCTAssertEqual(view.showedTodos?.count, 1)
        XCTAssertEqual(view.showedTodos?.first?.displayTitle, "Buy milk")
    }

    func testToggleTodoStatusChangesStatus() {
        let todos = [
            Todo(id: 1, title: nil, todo: "Test", completed: false, date: nil)
        ]
        presenter.didLoadTodos(todos)
        presenter.toggleTodoStatus(todoID: 1)
        XCTAssertNotNil(view.updatedTodo)
        XCTAssertTrue(view.updatedTodo?.completed == true)
    }

    func testDidTapShareOpensRouterWithCorrectText() {
        let todo = Todo(id: 1, title: "Title", todo: "Description", completed: false, date: nil)
        presenter.didTapShare(todo)
        XCTAssertNotNil(router.openedShareText)
        XCTAssertTrue(router.openedShareText!.contains("Title"))
        XCTAssertTrue(router.openedShareText!.contains("Description"))
    }
    
    func testCreateTodoCallsInteractor() {
        presenter.didTapAddNew()
    }

}
