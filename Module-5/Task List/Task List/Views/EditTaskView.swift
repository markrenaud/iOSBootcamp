//
//  EditTaskView.swift
//  Created by Mark Renaud (2023).
//
    
import SwiftUI

struct EditTaskView: View {
    @Binding var task: TaskItem
    
    var body: some View {
        Form {
            Section("Task Title") {
                TextField("Task Title", text: $task.title)
            }
            Section("Notes") {
                TextField("Notes", text: $task.notes, axis: .vertical)
                    .lineLimit(5...10)
            }
            Section {
                Toggle("Completed:", isOn: $task.isCompleted)
            }
        }
    }
}

#Preview {
    EditTaskView(task: .constant(.completedSampleTask))
}
