//
//  ListTodoRouter.swift
//  Notes
//
//  Created by Хван Эдуард on 16.09.2025.
//

import UIKit

class ListTodoRouter: ListTodoRouterProtocol {
    func createModule(coreDataStack: CoreDataStack) -> UIViewController {
        let view = ListTodoViewController()
        let presenter = ListTodoPresenter()
        let interactor = ListTodoInteractor(coreDataStack: coreDataStack)
        let router = ListTodoRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
    
    func presentAddTodoScreen(from view: ListTodoViewProtocol, delegate: AddTodoDelegate) {
    }
    
    func presentEditTodoScreen(from view: ListTodoViewProtocol, todo: TodoItem, delegate: EditTodoDelegate) {
    }
}
