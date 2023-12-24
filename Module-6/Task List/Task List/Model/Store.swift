//
//  Store.swift
//  Created by Mark Renaud (2023).
//

import Foundation

class Store: ObservableObject {
    /// All tasks saved to the list.
    @Published var tasks: [TaskItem] { 
        // see remarks in pull request
        didSet {
            implementCustomChangeLogic()
        }
    }

    init(tasks: [TaskItem] = []) {
        self.tasks = tasks
    }

    func addTask(_ task: TaskItem) {
        tasks.append(task)
    }
    
    // MARK: - Non required methods for assignment
    //         The following is not part of the assignment.  It is in relation
    //         to discussion re implementation details in assignment review
    //         pull request.
    private (set) var taskChangesSinceLaunch: Int = 0
    
    private func implementCustomChangeLogic() {
        // it is the Store's responsibility to monitor for change
        // to itself
        print("Custom logic on task change here")
        taskChangesSinceLaunch += 1
    }
}
