## ToDo List Test Assignment

Simple iOS application for managing a ToDo list.

## Screenshots

<p float="left">
  <img src="ScreenShots/All tasks.png" width="250" />
  <img src="ScreenShots/Card.png" width="250" />
  <img src="ScreenShots/Change.png" width="250" />
    <img src="ScreenShots/Share 1.png" width="250" />
      <img src="ScreenShots/Search.png" width="250" />
        <img src="ScreenShots/New task.png" width="250" />
</p>

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
