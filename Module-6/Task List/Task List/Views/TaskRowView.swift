//
//  TaskRowView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct TaskRowView: View {
    let task: TaskItem
    var body: some View {
        HStack {
            Text(task.title)
            Spacer()
            Image(systemName: task.isCompleted ? Constants.Symbol.checked : Constants.Symbol.unchecked)
                .foregroundStyle(task.isCompleted ? Constants.Color.checked : Constants.Color.unchecked)
        }
        .font(Constants.Font.taskItemList)
        .padding()
    }
}

#Preview {
    VStack {
        TaskRowView(task: .completedSampleTask)
        TaskRowView(task: .incompleteSampleTask)
    }
}
