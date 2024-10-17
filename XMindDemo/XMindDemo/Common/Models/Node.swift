//
//  Node.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/17.
//

import Foundation

struct Node: Codable {
    var id: String
    var height: Double
    var childrenHeight: Double
    var width: Double
    var lines: [String]
    var lineHeight: Double
    var title: String
    var content: String
    var parent: String //parentId
    var startDate: String
    var endDate: String
    var children: [Node]
}
