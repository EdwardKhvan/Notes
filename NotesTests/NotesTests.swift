import XCTest
@testable import Notes

class TodoListTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var interactor: ListTodoInteractor!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack()
        interactor = ListTodoInteractor(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        coreDataStack = nil
        interactor = nil
        super.tearDown()
    }
    
    func testSaveAndRetrieveTodo() {
        let expectation = self.expectation(description: "Save and retrieve todo")
        
        let todo = TodoItem(
            id: 1,
            title: "Test Todo",
            description: "Test Description",
            createdAt: Date(),
            completed: false,
            userId: 1
        )
        
        interactor.saveTodo(todo)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.interactor.retrieveTodos()
            
            let mockPresenter = MockListTodoInteractorOutput()
            mockPresenter.expectation = expectation
            self.interactor.presenter = mockPresenter
            
            self.waitForExpectations(timeout: 5) { error in
                if let error = error {
                    XCTFail("waitForExpectations errored: \(error)")
                } else {
                    XCTAssertEqual(mockPresenter.todos.count, 1)
                    XCTAssertEqual(mockPresenter.todos.first?.title, "Test Todo")
                }
            }
        }
    }
}

class MockListTodoInteractorOutput: ListTodoInteractorOutputProtocol {
    
    func onSuccess(_ message: String) {
    }
    
    var expectation: XCTestExpectation?
    var todos: [TodoItem] = []
    
    func didRetrieveTodos(_ todos: [TodoItem]) {
        self.todos = todos
        expectation?.fulfill()
    }
    
    func didSaveTodo(_ todo: TodoItem) {}
    func didDeleteTodo(_ todo: TodoItem) {}
    func onError(_ message: String) {}
}
