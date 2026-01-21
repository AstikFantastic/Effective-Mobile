import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func showTodos(_ todos: [Todo])
    func showError(_ message: String)
    func updateTodo(at index: Int, todo: Todo)
}

final class MainViewController: UIViewController, MainViewControllerProtocol {
    
    var presenter: MainViewControllerPresenterProtocol?
    
    private var todos: [Todo] = []
    private let tableView = UITableView()
    
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup UI
    func setupUI() {

        view.backgroundColor = .black
        
        tableView.register(ToDoListCell.self, forCellReuseIdentifier: ToDoListCell.identifier)
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .systemGray
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func showTodos(_ todos: [Todo]) {
        self.todos = todos
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        
    }
    
    func updateTodo(at index: Int, todo: Todo) {
        todos[index] = todo

        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}


// MARK: - TableView Data Source and Delegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
                withIdentifier: ToDoListCell.identifier,
                for: indexPath
            ) as! ToDoListCell

            let todo = todos[indexPath.row]
            cell.configurate(with: todo)

            cell.onStatusTap = { [weak self] in
                self?.presenter?.toggleTodoStatus(at: indexPath.row)
            }

            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
//    func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            presenter?.didDeleteTodo(at: indexPath.row)
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
}
