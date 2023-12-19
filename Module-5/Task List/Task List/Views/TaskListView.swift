//
//  TaskListView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var store: Store
    @State private var showingNewTask: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach($store.tasks) { $task in
                        NavigationLink {
                            EditTaskView(task: $task)
                        } label: {
                            TaskRowView(task: task)
                        }
                    }
                }
            }
            .navigationTitle("MyTasks")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(
                            action: {
                                showingNewTask.toggle()
                            }, label: {
                                HStack {
                                    Image(systemName: Constants.Symbol.addItem)
                                    Text("New Task")
                                }
                            }
                        )
                        .font(Constants.Font.toolbarButton)
                        Spacer()
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewTask) {
            NewTaskView()
        }
    }
}

#Preview {
    TaskListView()
        .environmentObject(Store(tasks: .sampleTasks))
}
