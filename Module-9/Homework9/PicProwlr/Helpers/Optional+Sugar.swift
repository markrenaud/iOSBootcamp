//
//  Optional+Sugar.swift
//  Created by Mark Renaud (2024).
//

import Foundation

extension Optional {
    var isNil: Bool {
        return self == nil
    }
    
    var notNil: Bool {
        return self != nil
    }
}
