//
//  TaskCriteriaTests.swift
//  Created by Mark Renaud (2023).
//
    


@testable import Task_List
import XCTest

final class TaskCriteriaTests: XCTestCase {

    let sampleTasks: [TaskItem] = .sampleTasks
    
    func testCriteriaAll() {
        let filteredTasks = sampleTasks.filter{ TaskCriteria.all.match($0) }
        XCTAssertEqual(filteredTasks.count, sampleTasks.count)
    }

    func testCriteriaCompleted() {
        let filteredTasks = sampleTasks.filter{ TaskCriteria.completed.match($0) }
        XCTAssertEqual(filteredTasks.count, 2)
    }

    func testCriteriaIncomplete() {
        let filteredTasks = sampleTasks.filter{ TaskCriteria.incomplete.match($0) }
        XCTAssertEqual(filteredTasks.count, 3)
    }

    func testCriteriaTitle() {
        let filteredTasks = sampleTasks.filter{ TaskCriteria.titleContains("ca").match($0) }
        XCTAssertEqual(filteredTasks.count, 2)
    }
    
    func testCombinedAnd() {
        let filteredTasks = sampleTasks.filter{ TaskCriteria.completed.and(.titleContains("ca")).match($0) }
        XCTAssertEqual(filteredTasks.count, 1)
        XCTAssertEqual(filteredTasks.first?.title, "Recharge the car")
    }


}
