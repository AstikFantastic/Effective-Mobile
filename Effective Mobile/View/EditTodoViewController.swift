import UIKit

enum EditMode {
    case create
    case edit(Todo)
}

final class EditTodoViewController: UIViewController {
    
    private let mode: EditMode
    
    var interactor: TodoListInteractorProtocol?
    
    init(todo: Todo) {
        self.mode = .edit(todo)
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        self.mode = .create
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var headerTextField = UITextField()
    private var datePicker = UIDatePicker()
    private var descriptionTextView = UITextView()
    private let descriptionPlaceholder = "Enter description"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            saveChanges()
        }
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        switch mode {
        case .create:
            headerTextField.text = ""
            descriptionTextView.text = ""
            datePicker.date = Date()
        case .edit(let todo):
            headerTextField.text = todo.title ?? "Task № \(todo.id)"
            descriptionTextView.text = todo.todo
            datePicker.date = todo.date ?? Date()
        }
        
        headerTextField.textColor = .white
        headerTextField.font = UIFont.systemFont(ofSize: 33, weight: .bold)
        headerTextField.placeholder = "Task"
        view.addSubview(headerTextField)
        
        datePicker.datePickerMode = .date
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 10
        datePicker.clipsToBounds = true
        view.addSubview(datePicker)
        
        descriptionTextView.textColor = .white
        descriptionTextView.font = UIFont.systemFont(ofSize: 15)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isScrollEnabled = true
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = descriptionPlaceholder
            descriptionTextView.textColor = .systemGray
        }
        descriptionTextView.delegate = self
        view.addSubview(descriptionTextView)
        
        [headerTextField, descriptionTextView, datePicker].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.topAnchor.constraint(equalTo: headerTextField.bottomAnchor, constant: 20),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func saveChanges() {
        let rawTitle = headerTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let rawDescription = descriptionTextView.text == descriptionPlaceholder ? "" : descriptionTextView.text
        let newDescription = rawDescription?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let newDate = datePicker.date
        let finalTitle: String? = (rawTitle?.isEmpty == true) ? nil : rawTitle
        
        switch mode {
        case .create:
            interactor?.createTodo(title: finalTitle ?? "Task", description: newDescription, date: newDate)
        case .edit(let todo):
            interactor?.updateTodoInformation(id: todo.id, title: finalTitle ?? "Task", desctiption: newDescription, date: newDate)
        }
        
    }
    
}

// MARK: - Extensoin for UITextView

extension EditTodoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == descriptionPlaceholder {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = descriptionPlaceholder
            textView.textColor = .systemGray
        }
    }
}
