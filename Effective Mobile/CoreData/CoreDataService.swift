import CoreData
import UIKit


final class CoreDataService {
    
    static let shared = CoreDataService()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchTodos() -> [Todo] {
        
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let entities = (try? context.fetch(request)) ?? []
        
        return entities.map {
            Todo(
                id: Int($0.id),
                todo: $0.todo ?? "",
                completed: $0.completed,
                date: $0.date
            )
        }
    }

    func saveTodos(_ todos: [Todo]) {
        
        todos.forEach { todo in
            let entity = ToDoEntity(context: context)
            entity.id = Int64(todo.id)
            entity.todo = todo.todo
            entity.completed = todo.completed
            entity.date = todo.date
        }
        
        try? context.save()
    }
    
    
    
    
}
