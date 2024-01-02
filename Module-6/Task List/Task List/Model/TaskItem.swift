//
//  TaskItem.swift
//  Created by Mark Renaud (2023).
//

import Foundation

// Note: Used `TaskItem` (cf. `Task` as suggested in homework) to avoid
//       namespace conflicts with Swift's concurrency `Task`.
struct TaskItem: Identifiable, Hashable {
    let id = UUID()

    var title: String
    var notes: String

    var category: TaskCategory

    var isCompleted: Bool

    init(title: String = "", notes: String = "", category: TaskCategory = .uncategorized, isCompleted: Bool = false) {
        self.title = title
        self.notes = notes
        self.category = category
        self.isCompleted = isCompleted
    }
}

extension [TaskItem] {
    func count(of category: TaskCategory) -> Int {
        self
            .filter { $0.category == category }
            .count
    }
}

extension TaskItem {
    static let completedSampleTask = TaskItem(
        title: "Get salt for the pool",
        notes: "Analyser suggesting low salt levels.  Ask pool store to estimate how many bags of salt we need to get through summer.",
        category: .home,
        isCompleted: true
    )

    static let incompleteSampleTask = TaskItem(
        title: "Buy nice bottle of wine for dinner party.",
        notes: "Main course will be chicken.  One of the guests hates Sauvignon Blanc.  Maybe get a Pinot Gris from the Adelaide Hills?",
        category: .home,
        isCompleted: false
    )
}

extension [TaskItem] {
    static let sampleTasks: [TaskItem] = [
        .completedSampleTask,
        .incompleteSampleTask,
        TaskItem(
            title: "Pick up delivery from parcel locker",
            notes: "Pin code for locker is 1234#",
            category: .work
        ),
        TaskItem(
            title: "Recharge the car",
            isCompleted: true
        ),
        TaskItem(
            title: "Call parents",
            category: .personal,
            isCompleted: false
        ),
    ]
}
