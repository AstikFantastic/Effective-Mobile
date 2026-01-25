import UIKit

final class ToDoListCell: UITableViewCell {
    
    static let identifier = "ToDoListCell"
    
    private let title = UILabel()
    private var dateLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let statusView = UIView()
    private let checkMark = UIImageView()
    private let containerView = UIView()
    
    var onStatusTap: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.attributedText = nil
        checkMark.isHidden = true
        statusView.backgroundColor = .clear
    }
    
    private func setupUI() {
        containerView.backgroundColor = .black
        
        statusView.layer.cornerRadius = 12
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(statusTapped)
        )
        statusView.addGestureRecognizer(tap)
        statusView.isUserInteractionEnabled = true
        
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
        
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .systemGray
        
        contentView.addSubview(containerView)
        containerView.addSubview(statusView)
        statusView.addSubview(checkMark)
        containerView.addSubview(title)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(dateLabel)
        
        [containerView, statusView, title, descriptionLabel, dateLabel, checkMark].forEach {
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
            
            dateLabel.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -7)
        ])
        
    }
    
    @objc func statusTapped() {
        onStatusTap?()
    }
    
    func configurate(with todo: Todo) {
        let attributes: [NSAttributedString.Key: Any] = todo.completed
        ? [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.systemGray
        ] : [
            .strikethroughStyle: 0,
            .foregroundColor: UIColor.white
        ]

        let titleText = todo.title ?? "Task № \(todo.id)"
        title.attributedText = NSAttributedString(string: titleText, attributes: attributes)
        
        if !todo.completed {
            statusView.layer.borderWidth = 1
            statusView.layer.borderColor = UIColor.systemYellow.cgColor
        } else {
            statusView.backgroundColor = .yellow
        }
        descriptionLabel.text = todo.todo
        
        if let date = todo.date {
            dateLabel.text = format(date: date)
        } else {
            dateLabel.text = "Select a date"
        }
        
        checkMark.isHidden = !todo.completed
        
    }
    
    private func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
