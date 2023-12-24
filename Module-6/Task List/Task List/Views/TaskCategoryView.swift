//
//  TaskCategoryView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct TaskCategoryView: View {
    @Binding var tasks: [TaskItem]
    @State var selectedCategory: TaskCategory? = nil

    var searchCriteria: TaskCriteria {
        guard let selectedCategory else {
            return .all
        }
        return .category(selectedCategory)
    }

    var body: some View {
        NavigationStack {
            VStack {
                CategoryGrid(
                    tasks: $tasks,
                    selectedCategory: $selectedCategory
                )
                .padding(20)
                TaskList(
                    tasks: $tasks,
                    criteria: searchCriteria
                )
            }
        }
    }
}

private struct PreviewHelper: View {
    @State private var tasks: [TaskItem] = .sampleTasks
    var body: some View {
        TaskCategoryView(tasks: $tasks)
    }
}

#Preview {
    PreviewHelper()
}
