import UIKit

final class EditTodoViewController: UIViewController {
    
    private var todo: Todo
    var interactor: TodoListInteractorProtocol?
    
    init(todo: Todo) {
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var headerTextField = UITextField()
    private var datePicker = UIDatePicker()
    private var descriptionTextView = UITextView()
    private let descriptionPlaceholder = "Enter description"
    private var fallbackTitle: String {
        "Task № \(todo.id)"
    }
    
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
        
        headerTextField.text = todo.title ?? fallbackTitle
        headerTextField.textColor = .white
        headerTextField.font = UIFont.systemFont(ofSize: 33, weight: .bold)
        headerTextField.placeholder = fallbackTitle
        view.addSubview(headerTextField)
        
        datePicker.date = todo.date ?? Date()
        datePicker.datePickerMode = .date
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 10
        datePicker.clipsToBounds = true
        view.addSubview(datePicker)
        
        descriptionTextView.text = todo.todo
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
        interactor?.updateTodoInformation(id: todo.id, title: finalTitle ?? "Task", desctiption: newDescription, date: newDate)
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
