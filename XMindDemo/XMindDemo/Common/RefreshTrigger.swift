//
//  RefreshTrigger.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/21.
//

import Foundation

class RefreshTrigger: ObservableObject {
    static let shared = RefreshTrigger()
    
    @Published private var refreshTrigger: UUID = UUID()
    
    func refresh() {
        refreshTrigger = UUID()
    }
}
