//
//  NewTaskView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: Store
    @State private var newTask = TaskItem()

    var body: some View {
        NavigationStack {
            TaskForm(task: $newTask, showCompletionToggle: false)
                .navigationTitle("New Task")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            store.addTask(newTask)
                            dismiss()
                        }
                        .disabled(newTask.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
        }
    }
}

#Preview {
    NewTaskView()
        .environmentObject(Store(tasks: .sampleTasks))
}
