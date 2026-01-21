import UIKit

protocol TodoListInteractorProtocol: AnyObject {
    func loadTodos()
    //    func deleteTodo(at index: Int)
    //    func filterTodos(text: String)
    
}

final class ToDoInteractor: TodoListInteractorProtocol {
    
    
    weak var presenter: MainViewControllerPresenterProtocol?
    private var todos: [Todo] = []
    
    func loadTodos() {
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
                self.todos = response.todos
                DispatchQueue.main.async {
                    self.presenter?.didLoadTodos(self.todos)
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didLoadTodos(self.todos)
                }
            }
        }.resume()
    }
}

