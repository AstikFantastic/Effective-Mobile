import UIKit

final class TodoCellPreviewController: UIViewController {
    
    private let todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        let card = UIView()
        card.backgroundColor = .darkGray
        card.layer.cornerRadius = 16
        card.layer.masksToBounds = true
        
        let header = UILabel()
        header.text = "Task № \(todo.id)"
        header.textColor = .white
        header.font = .systemFont(ofSize: 17, weight: .bold)
        
        let description = UILabel()
        description.text = todo.todo
        description.textColor = .lightGray
        description.font = .systemFont(ofSize: 13)
        description.numberOfLines = 0
        
        let dateLabel = UILabel()
        if let date = todo.date {
            dateLabel.text = format(date: date)
        } else {
            dateLabel.text = "Select a date"
        }
        dateLabel.textColor = .lightGray
        dateLabel.font = .systemFont(ofSize: 10)
        
        let stack = UIStackView(arrangedSubviews: [header, description, dateLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.setCustomSpacing(4, after: header)
        stack.setCustomSpacing(2, after: description)
        header.setContentHuggingPriority(.required, for: .vertical)
        dateLabel.setContentHuggingPriority(.required, for: .vertical)

        card.addSubview(stack)
        view.addSubview(card)
        
        [header, description, stack, card, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            card.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            card.topAnchor.constraint(equalTo: view.topAnchor),
            card.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 25),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -25),
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10)
        ])
        
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 50, height: 120)
    }
    
    private func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
