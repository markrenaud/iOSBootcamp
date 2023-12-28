//
//  DiffTaskItemArray.swift
//  Created by Mark Renaud (2023).
//
    

import Foundation

extension CollectionDifference where ChangeElement == TaskItem {
    /// A helper to log the difference in an array of `TaskItem`s in a more
    /// concise and readable way.
    var conciseDebug: String {
        var output: String = ""
        for difference in self {
            switch difference {
            case .insert(offset: _, element: let task, associatedWith: _):
                output += simpleStringLine(task: task, prefix: "+")
            case .remove(offset: _, element: let task, associatedWith: _):
                output += simpleStringLine(task: task, prefix: "-")
            }
        }
        return output
    }
    
    fileprivate func simpleStringLine(task: TaskItem, prefix: String) -> String {
        "\n\(prefix)[`\(task.title)` | completed: \(task.isCompleted ? "Y" : "N")]"
    }
}
