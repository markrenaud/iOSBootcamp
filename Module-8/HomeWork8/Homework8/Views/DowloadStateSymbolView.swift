//
//  DownloadStateSymbolView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct DownloadStateSymbolView: View {
    let state: DownloadState
    
    /// The time (delay in seconds) after reaching a completed state for the view
    /// when the view will hide itself.
    /// If this property is set to `nil`, the view will not autohide.
    let autoHideDelay: TimeInterval?
    
    @State private var rotation: Double = 0.0
    @State private var hidden: Bool = false
    
    private var shouldAnimate: Bool {
        if case .downloading = state { return true }
        return false
    }
    
    init(state: DownloadState, autoHideDelay: TimeInterval? = nil) {
        self.state = state
        self.autoHideDelay = autoHideDelay
    }
    
    var body: some View {
        if hidden {
            EmptyView()
        } else {
            HStack {
                if #available(iOS 17.0, *) {
                    Image(systemName: state.symbolName)
                        .font(.title)
                        .foregroundStyle(.primary)
                        .symbolRenderingMode(.multicolor)
                        .contentTransition(.symbolEffect(.replace.byLayer))
                        .rotationEffect(.degrees(shouldAnimate ? 360 : 0))
                        .animation(shouldAnimate ? .linear(duration: 2).repeatForever(autoreverses: false) : .default, value: shouldAnimate)
                } else {
                    Image(systemName: state.symbolName)
                        .font(.title)
                        .foregroundStyle(.primary)
                        .symbolRenderingMode(.multicolor)
                        .rotationEffect(.degrees(shouldAnimate ? 360 : 0))
                        .animation(shouldAnimate ? .linear(duration: 2).repeatForever(autoreverses: false) : .default, value: shouldAnimate)
                }
                if case .downloading(progress: .percent(let progress)) = state {
                    ProgressView(value: progress, total: 1.0)
                }
            }
            .onChange(of: state, perform: { changedState in
                // prepare to autohide after delay
                if
                    let autoHideDelay,
                    changedState == .completed
                {
                    QuickLog.ui.info("Will autohide in \(autoHideDelay) seconds")
                    Task { [self] in
                        try await Task.sleep(for: .seconds(autoHideDelay))
                        // recheck state after delay
                        // ensure we are still in completed state, and have
                        // the download has not recommenced
                        await MainActor.run {
                            withAnimation {
                                self.hidden = true
                            }
                        }
                    }
                }
            })
        }
    }
}

private extension DownloadState {
    var symbolName: String {
        switch self {
        case .pending:
            return "circle.hexagongrid.circle"
        case .downloading:
            return "circle.hexagongrid.circle.fill"
        case .completed:
            return "checkmark.circle"
        case .failed:
            return "exclamationmark.circle"
        }
    }
}

private struct PreviewHelper: View {
    private let testStates: [DownloadState] = [
        .pending,
        .downloading(progress: .indeterminate),
        .downloading(progress: .percent(0.25)),
        .downloading(progress: .percent(0.50)),
        .downloading(progress: .percent(0.75)),
        .downloading(progress: .percent(1.00)),
        .completed,
        .failed
    ]
    
    @State private var state: DownloadState = .pending
    @State private var autoHideWhenComplete = false
    
    // autohide after 2 secs if toggle is on
    var autoHideDelay: TimeInterval? {
        autoHideWhenComplete ? 1 : nil
    }
    
    var body: some View {
        VStack {
            Toggle("Autohide on completion", isOn: $autoHideWhenComplete)
            HStack {
                Button("Next State") { nextState() }
                    .buttonStyle(.borderedProminent)
                DownloadStateSymbolView(state: state, autoHideDelay: autoHideDelay)
                Spacer(minLength: 0)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    func nextState() {
        withAnimation {
            let maxIndex = testStates.count - 1
            if let currentIndex = testStates.firstIndex(of: state) {
                if currentIndex < maxIndex {
                    state = testStates[currentIndex + 1]
                } else {
                    state = testStates[0]
                }
            }
        }
    }
}

#Preview {
    PreviewHelper()
}
