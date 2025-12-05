//
//  Item.swift
//  apple-intelligence-demo
//
//  Created by Clément Sauvage on 29/11/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
