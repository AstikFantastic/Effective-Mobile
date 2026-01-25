import UIKit

protocol TodoListInteractorProtocol: AnyObject {
    func loadTodos()
    func deleteTodo(id: Int)
    func updateTodoInformation(id: Int, title: String, desctiption: String, date: Date?)
    func updateTodoCompleted(id: Int, complited: Bool)
}

final class ToDoInteractor: TodoListInteractorProtocol {

    weak var presenter: MainViewControllerPresenterProtocol?
    private let coreData = CoreDataService.shared
    
    func loadTodos() {
        let cachedTodos = coreData.fetchTodos()
        if !cachedTodos.isEmpty {
            presenter?.didLoadTodos(cachedTodos)
            return
        }
        fetchFromnetwork()
    }
    
    
    func deleteTodo(id: Int) {
        coreData.deleteTodo(id: id)
    }
    
    func updateTodoInformation(id: Int, title: String, desctiption: String, date: Date?) {
        coreData.updateTodoInformation(id: id, title: title, description: desctiption, date: date)
    }
    
    func updateTodoCompleted(id: Int, complited: Bool) {
        coreData.updateTodoCompleted(id: id, complited: complited)
    }
    
    
    private func fetchFromnetwork() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                self.presenter?.didFail(error: error)
            }
            guard let data = data else { return }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response:\n\(jsonString)")
            } else {
                print("Error: Unable to convert data to string.")
            }
            do {
                let response = try JSONDecoder().decode(EmbeddedModel.self, from: data)
                self.coreData.saveTodos(response.todos)
                DispatchQueue.main.async {
                    self.presenter?.didLoadTodos(response.todos)
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFail(error: error)
                }
            }
        }.resume()
    }
}

