//
//  StoreTests.swift
//  Created by Mark Renaud (2023).
//

@testable import Task_List
import XCTest

final class Task_ListTests: XCTestCase {
    var sampleStore = Store(tasks: .sampleTasks)

    func testTasksChanged() throws {
        let preChangeCount = sampleStore.taskChangesSinceLaunch
        
        // update completion state of first task
        sampleStore.tasks[0].isCompleted.toggle()
        
        let postChangeCount = sampleStore.taskChangesSinceLaunch
        let expectedPostChangeCount = preChangeCount + 1
        
        XCTAssertEqual(expectedPostChangeCount, postChangeCount)
    }
}
