import UIKit

final class ToDoListCell: UITableViewCell {
    
    static let identifier = "ToDoListCell"
    
    private let title = UILabel()
    private var date = UILabel() // Скорректировать дату
    private let descriptionLabel = UILabel()
    private let statusView = UIView()
    private let checkMark = UIImageView()
    private let containerView = UIView()
    
    private let attributes: [NSAttributedString.Key: Any] = [
        .strikethroughStyle: NSUnderlineStyle.single.rawValue,
        .foregroundColor: UIColor.systemGray
    ]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.backgroundColor = .black
        
        statusView.layer.cornerRadius = 12
        
        checkMark.image = UIImage(systemName: "checkmark")
        checkMark.tintColor = .black
        checkMark.isHidden = true
        
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.textColor = .white
        title.numberOfLines = 2
        
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .justified
        descriptionLabel.numberOfLines = 2
        
        date.font = .systemFont(ofSize: 13)
        date.textColor = .systemGray
        
        contentView.addSubview(containerView)
        containerView.addSubview(statusView)
        statusView.addSubview(checkMark)
        containerView.addSubview(title)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(date)
        
        [containerView, statusView, title, descriptionLabel, date, checkMark].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            statusView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            statusView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            statusView.widthAnchor.constraint(equalToConstant: 24),
            statusView.heightAnchor.constraint(equalToConstant: 24),
            
            checkMark.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            checkMark.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            
            title.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            
            
            date.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            date.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -7)
        ])

    }
    
    func configurate(with todo: Todo) {
        title.text = String("Task № \(todo.id)")
        descriptionLabel.text = todo.todo
        
        date.text = "Today"
        
        if todo.completed {
            title.attributedText = NSAttributedString(
                string: title.text ?? "Tast № \(todo.id)",
                attributes: attributes
            )
            statusView.backgroundColor = .systemYellow
            statusView.layer.borderColor = UIColor.systemYellow.cgColor
            checkMark.isHidden = false
        } else {
            title.attributedText = NSAttributedString(
                string: "Tast № \(todo.id)",
                attributes: [.foregroundColor: UIColor.white]
            )
            statusView.backgroundColor = .clear
            statusView.layer.borderColor = UIColor.systemYellow.cgColor
            statusView.layer.borderWidth = 1
            checkMark.isHidden = true
        }
    }
}


