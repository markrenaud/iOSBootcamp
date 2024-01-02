//
//  BaseView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct BaseView: View {
    @EnvironmentObject var store: Store
    @State private var selectedTab: BaseView.Tab = .tasks

    enum Tab: String, Hashable {
        case tasks
        case completed
        case categories

        var title: String { rawValue.capitalized }
        
        var label: some View {
            switch self {
            case .tasks:
                Label(title, systemImage: Constants.Symbol.tasksTab)
            case .completed:
                Label(title, systemImage: Constants.Symbol.completedTab)
            case .categories:
                Label(title, systemImage: Constants.Symbol.categoriesTab)
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            TaskListView(
                tasks: $store.tasks,
                listTitle: Tab.tasks.title,
                baseCriteria: .incomplete
            )
            .tabItem { Tab.tasks.label }
            .tag(Tab.tasks)

            TaskListView(
                tasks: $store.tasks,
                listTitle: Tab.completed.title,
                baseCriteria: .completed
            )
            .tabItem { Tab.completed.label }
            .tag(Tab.completed)

            TaskCategoryView(
                tasks: $store.tasks
            )
            .tabItem { Tab.categories.label }
            .tag(Tab.categories)
        }
    }
}

#Preview {
    BaseView()
        .environmentObject(Store(tasks: .sampleTasks))
}
