//
//  Enum.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/17.
//

import Foundation

enum MindType: CaseIterable {
    case canvas, native, cmaker
    
    func rowTitle() -> String {
        switch self {
        case .canvas:
            "js-canvas"
        case .native:
            "native-swiftUI"
        case .cmaker:
            "c render"
        }
    }
    
    func filePath() -> String {
        switch self {
        case .canvas:
            "canvas.json"
        case .native:
            "native.json"
        case .cmaker:
            "cmaker.json"
        }
    }
}
