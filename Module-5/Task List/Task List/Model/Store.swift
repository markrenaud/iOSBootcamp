//
//  Store.swift
//  Created by Mark Renaud (2023).
//

import Foundation

class Store: ObservableObject {
    /// All tasks saved to the list.
    @Published var tasks: [TaskItem]

    init(tasks: [TaskItem] = []) {
        self.tasks = tasks
    }

    func addTask(_ task: TaskItem) {
        tasks.append(task)
    }
    
    func complete(_ taskID: UUID) {
        if let storeIndex = tasks.firstIndex(where: { $0.id == taskID }) {
            tasks[storeIndex].isCompleted = true
        }
    }
    
    func complete(_ task: TaskItem) {
        complete(task.id)
    }
}
