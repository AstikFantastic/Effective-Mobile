## ToDo List Test Assignment

Simple iOS application for managing a ToDo list.

### Features
- Display list of tasks on the main screen  
- Each task contains: title, description, creation date and status  
- Add new tasks  
- Edit existing tasks  
- Delete tasks  
- Search tasks by title and description  

### Data & Networking
- Initial tasks are loaded from: https://dummyjson.com/todos  
- Tasks are stored locally using CoreData  
- App restores saved data on next launch  
- All create, load, update, delete and search operations are performed in background threads
- UI remains responsive during all operations  

### Architecture
- VIPER architecture  

### Testing
- Unit tests implemented for Presenter layer  
- Mocks used for View, Interactor and Router  

### Technologies
- Swift  
- UIKit  
- CoreData  
- GCD  
- VIPER  
- XCTest  
