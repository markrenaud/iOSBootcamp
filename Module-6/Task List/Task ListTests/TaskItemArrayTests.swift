//
//  TaskItemArrayTests.swift
//  Created by Mark Renaud (2023).
//
    
@testable import Task_List
import XCTest

final class TaskItemArrayTests: XCTestCase {
    
    let sampleTasks: [TaskItem] = .sampleTasks

    func testCountOfCategory() throws {
        XCTAssertEqual(sampleTasks.count(of: .home), 2)
    }

}
