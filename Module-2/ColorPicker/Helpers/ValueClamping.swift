//
//  ValueClamping.swift
//  Created by Mark Renaud (2023).
//

import Foundation

extension Comparable {
    /// Clamps a value within a  given closed range.
    /// If the value  falls outside the range, the returned value will be the lower or upper bound
    /// of the range.
    /// If the value falls within the range, the original value will be returned.
    func clamped(_ range: ClosedRange<Self>) -> Self {
        if self < range.lowerBound { return range.lowerBound }
        if self > range.upperBound { return range.upperBound }
        return self
    }
}

/// Constrains the stored value of an Int to a ClosedRange.
@propertyWrapper struct Clamped<Value> where Value: Comparable {
    
    private var nonConstrainedValue: Value
    private let allowedRange: ClosedRange<Value>
    
    init(wrappedValue: Value, _ allowedRange: ClosedRange<Value>) {
        self.nonConstrainedValue = wrappedValue
        self.allowedRange = allowedRange
    }
    
    var wrappedValue: Value {
        get { nonConstrainedValue.clamped(allowedRange) }
        set { nonConstrainedValue = newValue }
    }
    
}

struct RGB {
    @Clamped(0...255) var red: Int = 128
    @Clamped(0...255) var green: Int = 128
    @Clamped(0...255) var blue: Int = 128
    
}
