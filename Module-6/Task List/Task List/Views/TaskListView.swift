//
//  TaskListView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct TaskListView: View {
    @State private var showingNewTask: Bool = false
    @State private var showingSearch: Bool = false
    @State private var searchText: String = ""
    @Binding var tasks: [TaskItem]
    let listTitle: String
    let baseCriteria: TaskCriteria

    private var searchCriteria: TaskCriteria {
        baseCriteria.and(.titleContains(searchText))
    }

    var body: some View {
        NavigationStack {
            TaskList(tasks: $tasks, criteria: searchCriteria)
                .searchable(text: $searchText, prompt: "search tasks")
                .navigationTitle(listTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        newTaskButton
                    }
                }
        }
        .sheet(isPresented: $showingNewTask) {
            NewTaskView()
        }
    }

    var newTaskButton: some View {
        Button(
            action: {
                showingNewTask.toggle()
            }, label: {
                HStack {
                    Image(systemName: Constants.Symbol.addItem)
                }
            }
        )
        .font(Constants.Font.toolbarButton)
    }
}

#Preview {
    TaskListView(tasks: .constant(.sampleTasks), listTitle: "Completed", baseCriteria: .completed)
}
