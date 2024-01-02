//
//  TaskRow.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct TaskRow: View {
    @Binding var task: TaskItem
    
    /// This property controls the animation state that indicates whether the
    /// task is marked as complete.
    ///
    /// This property helps animate the checkbox animation.  Once the animation is complete,
    /// the source of truth is updated - triggering the item to added/removed from the list.
    /// Having a 2-step process allows the animation to be interrupted, and reversed with the source
    /// of truth not being updated till the animation is complete.
    ///
    /// A 'placeholder' value of `false` is set on iniitalization.   The value is updated with
    /// the *truth* from the associated task in `.onAppear(_:)`.
    @State private var isMarkedCompleted: Bool = false

    var body: some View {

        QuickLog.ui.debug("TaskRow `\(task.title)` redrawn - isCompleted: \(task.isCompleted ? "Y" : "N") isMarkedCompletion: \(isMarkedCompleted ? "Y" : "N")")
        
        return HStack {
            Text(task.title)
            Spacer()
            Image(systemName: isMarkedCompleted ? Constants.Symbol.checked : Constants.Symbol.unchecked)
                .foregroundStyle(isMarkedCompleted ? Constants.Color.checked : Constants.Color.unchecked)
                .rotationEffect(.degrees(isMarkedCompleted ? 0 : 180))
                // The actual rendered size of the symbol
                // is controlled by the font applied and will
                // scale with dynamic types for accessibility.
                // At some rendered sizes, the rendered symbol may
                // be less than the HIG minimum tappable area of
                // 44 x 44 points.
                // Ensure the tappable area meets HIG without
                // affecting rendering of symbol.
                .frame(minWidth: 44, minHeight: 44)
                .contentShape(Rectangle())
                .onTapGesture { checkBoxTapped() }
        }
        .font(Constants.Font.taskItemList)
        .padding()
        .onAppear {
            isMarkedCompleted = task.isCompleted
        }
    }
    
    func checkBoxTapped() {
        // Toggle the desired final state for the animation.
        let desiredFinalState = !isMarkedCompleted
        
        // Define the duration of the symbol animation (`phase1`)
        let phase1Duration: TimeInterval = 0.5
        
        // Perform the animation to reflect the change in desired completion
        // state.
        if #available(iOS 17.0, *) {
            withAnimation(.linear(duration: phase1Duration)) {
                isMarkedCompleted = desiredFinalState
            } completion: {
                // Recheck in case the animation was interrupted and the
                // task's completion status no longer needs to be updated.
                if isMarkedCompleted == desiredFinalState {
                    withAnimation {
                        task.isCompleted = isMarkedCompleted
                        QuickLog.ui.debug("Updated task `\(task.title)` | isCompleted: \(task.isCompleted ? "Y" : "N")")
                    }
                }
            }
        } else {
            withAnimation(.linear(duration: phase1Duration)) {
                isMarkedCompleted = desiredFinalState
                Task {
                    try await Task.sleep(for: .seconds(phase1Duration))
                    // Recheck in case the animation was interrupted and the
                    // task's completion status no longer needs to be updated.
                    if isMarkedCompleted == desiredFinalState {
                        await MainActor.run {
                            withAnimation {
                                task.isCompleted = isMarkedCompleted
                                QuickLog.ui.debug("Updated task `\(task.title)` | isCompleted: \(task.isCompleted ? "Y" : "N")")
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct PreviewHelper: View {
    @State var taskA = TaskItem.completedSampleTask
    @State var taskB = TaskItem.incompleteSampleTask
    
    var body: some View {
        VStack {
            TaskRow(task: $taskA)
            TaskRow(task: $taskB)
        }
    }
}

#Preview {
    PreviewHelper()
}
