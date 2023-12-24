//
//  TaskList.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct TaskList: View {
    @Binding var tasks: [TaskItem]
    let criteria: TaskCriteria

    var body: some View {
        List {
            ForEach($tasks) { $task in
                if criteria.match(task) {
                    NavigationLink {
                        TaskForm(task: $task, showCompletionToggle: true)
                            .navigationTitle("Edit Task")
                    } label: {
                        TaskRow(task: $task)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

fileprivate struct PreviewHelper: View {
    
    @State var tasks: [TaskItem] = .sampleTasks
    
    var body: some View {
        NavigationStack {
            TaskList(tasks: $tasks, criteria: .incomplete)
        }
    }
}

#Preview {
    PreviewHelper()
}
