//
//  TaskForm.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct TaskForm: View {
    @Binding var task: TaskItem
    let showCompletionToggle: Bool

    var body: some View {
        Form {
            Section("Task Title") {
                TextField("Task Title", text: $task.title)
            }
            Section("Notes") {
                TextField("Notes", text: $task.notes, axis: .vertical)
                    .lineLimit(5 ... 10)
            }

            Section {
                Picker(
                    selection: $task.category)
                {
                    ForEach(TaskCategory.allCases) { category in
                        Text(category.title)
                            .tag(category)
                    }
                } label: {
                    Label("Category", systemImage: Constants.Symbol.tag)
                        .labelStyle(.titleAndIcon)
                }
            }
            if showCompletionToggle {
                Section {
                    Toggle(isOn: $task.isCompleted) {
                        Label("Completed", systemImage: Constants.Symbol.checked)
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
        }
    }
}

private struct PreviewHelper: View {
    @State private var sampleTask: TaskItem = .incompleteSampleTask
    var body: some View {
        TaskForm(task: $sampleTask, showCompletionToggle: true)
    }
}

#Preview {
    PreviewHelper()
}
