import UIKit

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListCell.identifier, for: indexPath) as! ToDoListCell
        let todo = todos[indexPath.row]
        cell.configurate(with: todo)
        cell.onStatusTap = { [weak self] in
            self?.presenter?.toggleTodoStatus(todoID: todo.id)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todo = todos[indexPath.row]
        presenter?.didSelectEditTodo(todo)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let todo = todos[indexPath.row]
        
        return UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: {
                return TodoCellPreviewController(todo: todo)
            }
        ) { _ in
            
            let edit = UIAction(
                title: "Edit",
                image: UIImage(systemName: "square.and.pencil")
            ) { _ in
                self.presenter?.didSelectEditTodo(todo)
            }
            
            let share = UIAction(
                title: "Share",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { _ in
                self.presenter?.didTapShare(todo)
            }
            
            let delete = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                self.presenter?.didTapDelete(at: indexPath.row)
            }
            return UIMenu(children: [edit, share, delete])
        }
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        showBlurImmediately()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.animateBlurIn()
        }
        guard let indexPath = configuration.identifier as? NSIndexPath,
              let cell = tableView.cellForRow(at: indexPath as IndexPath)
        else { return nil }
        let params = UIPreviewParameters()
        params.backgroundColor = .clear
        return UITargetedPreview(view: cell, parameters: params)
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        hideBlur()
        guard let indexPath = configuration.identifier as? NSIndexPath,
              let cell = tableView.cellForRow(at: indexPath as IndexPath)
        else { return nil }
        let params = UIPreviewParameters()
        params.backgroundColor = .clear
        return UITargetedPreview(view: cell, parameters: params)
    }
}
