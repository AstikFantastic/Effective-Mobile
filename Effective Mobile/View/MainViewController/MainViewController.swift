import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func showTodos(_ todos: [Todo])
    func showError(_ message: String)
    func updateTodo(at index: Int, todo: Todo)
}

final class MainViewController: UIViewController, MainViewControllerProtocol {
    
    var presenter: MainViewControllerPresenterProtocol?
    
    var todos: [Todo] = []
    private let tableView = UITableView()
    private let headerLabel = UILabel()
    private let searchBar = UISearchBar()
    private let bottomSafeArea = UIView()
    private let allTasksCount = UILabel()
    private let addNewTask = UIButton()
    let image = UIImage(
        systemName: "square.and.pencil",
        withConfiguration: UIImage.SymbolConfiguration(
            pointSize: 24,
            weight: .regular
        )
    )
    private var blurView: UIVisualEffectView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        hideKeyboard()
    }
    
    // MARK: - Setup UI
    func setupUI() {
        
        view.backgroundColor = .black
        
        headerLabel.text = "Tasks"
        headerLabel.textColor = .white
        headerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        headerLabel.textAlignment = .left
        
        view.addSubview(headerLabel)
        
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .darkGray
        searchBar.barTintColor = .black
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        
        tableView.register(ToDoListCell.self, forCellReuseIdentifier: ToDoListCell.identifier)
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .systemGray
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        
        
        view.addSubview(tableView)
        
        bottomSafeArea.backgroundColor = .darkGray
        
        view.addSubview(bottomSafeArea)
        
        allTasksCount.text = "\(todos.count) tasks"
        allTasksCount.textColor = .white
        allTasksCount.font = UIFont.systemFont(ofSize: 11)
        
        view.addSubview(allTasksCount)
        
        addNewTask.setImage(image, for: .normal)
        addNewTask.imageView?.tintColor = .yellow
        
        
        view.addSubview(addNewTask)
        
        [headerLabel, tableView, searchBar, bottomSafeArea, allTasksCount, addNewTask].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 5),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: bottomSafeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomSafeArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSafeArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSafeArea.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSafeArea.heightAnchor.constraint(equalToConstant: 83),
            
            allTasksCount.centerXAnchor.constraint(equalTo: bottomSafeArea.centerXAnchor),
            allTasksCount.centerYAnchor.constraint(equalTo: bottomSafeArea.centerYAnchor, constant: -20),
            
            addNewTask.centerYAnchor.constraint(equalTo: allTasksCount.centerYAnchor),
            addNewTask.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }
    
    // MARK: - Hide keyboard after screen tap
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyBoard() {
        view.endEditing(true)
    }
    
    //MARK: - Protocol methods
    
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
    
    //MARK: - Blur Methods
    
    func showBlurImmediately() {
        guard blurView == nil else { return }

        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0

        view.insertSubview(blurView, aboveSubview: tableView)
        self.blurView = blurView
    }

    func animateBlurIn() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseOut]
        ) {
            self.blurView?.alpha = 1
        }
    }
    
    func hideBlur() {
        guard let blurView else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            blurView.alpha = 0
        }) { _ in
            blurView.removeFromSuperview()
            self.blurView = nil
        }
    }
    
}



