//
//  Task_ListApp.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

@main
struct Task_ListApp: App {
    var body: some Scene {
        WindowGroup {
            BaseView()
                .environmentObject(Store(tasks: .sampleTasks))
        }
    }
}
