//
//  TaskCriteria.swift
//  Created by Mark Renaud (2023).
//

import Foundation

struct TaskCriteria {
    let match: (TaskItem) -> Bool
    
    init(_ predicate: @escaping (TaskItem) -> Bool) {
        self.match = predicate
    }
    
    /// Combines the current criteria with another criteria using a logical AND operation.
    ///
    /// This method returns a new `TaskCriteria` that represents the intersection of the current criteria and the provided `otherCriteria`.
    /// A `TaskItem` must satisfy both criteria in order to match the resulting combined criteria.
    func and(_ otherCriteria: TaskCriteria) -> TaskCriteria {
        TaskCriteria { task in
            self.match(task) && otherCriteria.match(task)
        }
    }
}

// Helpful default task filtering criteria.
extension TaskCriteria {
    static let all = TaskCriteria { _ in true }
    
    static let completed = TaskCriteria { $0.isCompleted ? true : false }
    static let incomplete = TaskCriteria { $0.isCompleted ? false : true }
    
    static func titleContains(_ searchText: String) -> TaskCriteria {
        // sanitise search text for comparison
        let sanitised = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        
        // if the sanitised search text is empty, then we are not searching
        // and should return all tasks.
        if sanitised.isEmpty { return .all }
        
        return TaskCriteria { task in
            // check title for sanitised search text.
            task.title.lowercased().contains(
                sanitised.trimmingCharacters(in: .whitespaces).lowercased()
            )
        }
    }
    
    static func category(_ taskCategory: TaskCategory) -> TaskCriteria {
        return TaskCriteria { $0.category == taskCategory }
    }
}
