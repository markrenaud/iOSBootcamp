//
//  Store.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

class Store: ObservableObject {
    /// All tasks saved to the list.
    @Published var tasks: [TaskItem]

    init(tasks: [TaskItem] = []) {
        self.tasks = tasks
    }

    func addTask(_ task: TaskItem) {
        tasks.append(task)
    }
}
