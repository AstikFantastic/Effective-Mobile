import CoreData
import UIKit


final class CoreDataService {
    
    static let shared = CoreDataService()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchTodos() -> [Todo] {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let entities = (try? context.fetch(request)) ?? []
        var needsSave = false
        let todos = entities.map { entity -> Todo in
            var title = entity.title
            if let t = title?.trimmingCharacters(in: .whitespacesAndNewlines),
               t == "Task №" || t.isEmpty {
                title = nil
                entity.title = nil
                needsSave = true
            }
            return Todo(
                id: Int(entity.id),
                title: title,
                todo: entity.todo ?? "",
                completed: entity.completed,
                date: entity.date
            )
        }
        if needsSave {
            try? context.save()
        }
        return todos
    }
    
    func saveTodos(_ todos: [Todo]) {
        for todo in todos {
            let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", todo.id)
            let entity = (try? context.fetch(request).first) ?? ToDoEntity(context: context)
            entity.id = Int64(todo.id)
            entity.todo = todo.todo
            entity.completed = todo.completed
            entity.date = todo.date
        }
        try? context.save()
    }
    
    func deleteTodo(id: Int) {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        guard let entity = try? context.fetch(request).first else { return }
        context.delete(entity)
        try? context.save()
    }
    
    func updateTodoInformation(id: Int, title: String?, description: String, date: Date?) {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        guard let entity = try? context.fetch(request).first else { return }
        entity.title = title
        entity.todo = description
        entity.date = date
        try? context.save()
    }
    
    func updateTodoCompleted(id: Int, complited: Bool) {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        guard let entity = try? context.fetch(request).first else { return }
        entity.completed = complited
        try? context.save()
    }

    func createTodo(title: String, description: String, date: Date?) {
        let entity = ToDoEntity(context: context)
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        let maxId = (try? context.fetch(request).map { Int($0.id) }.max()) ?? 0
        entity.id = Int64(maxId + 1)
        entity.title = title.isEmpty ? "New Task" : title
        entity.todo = description
        entity.completed = false
        entity.date = date
        do {
            try context.save()
        } catch {
        }
    }

}
