//
//  Node.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/17.
//

import Foundation

struct Node: Codable {
    static var defaultNode = getDefaultNode()
    
    var id: String
    var height: Double = 0.0
    var childrenHeight: Double = 0.0
    var width: Double = 0.0
    var lines: [String] = []
    var lineHeight: Double = 0.0
    var title: String = ""
    var content: String = ""
    var parent: String = "" //parentId
    var children: [Node] = []
    
    private init() {
        id = UUID().uuidString
    }
}

extension Node {
    /// 这个方法是为了适配从progressDash移植过来的mindMap数据结构而存在的
    /// progressDash是我的一款独立作品，并不是第三方代码
    func rootJson() -> String {
        if let jsonData = try? JSONEncoder().encode(["root" : self]) {
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        return ""
    }
    
    func save(_ type: MindType) {
        guard let fileURL = CommonUtils.shared.getStorePath(type) else { return }
        
        do {
            guard let data = jsonData() else { return }
            try data.write(to: fileURL)
            print("File saved to \(fileURL)")
        } catch {
            print("Failed to save file: \(error)")
        }
    }
    
    private func jsonData() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            print("Encode Failed!")
            return nil
        }
    }
    
    private static func getDefaultNode() -> Node {
        var root = Node()
        root.title = "Root"
        
        var child1 = Node()
        child1.title = "Child1"
        
        root.children = [child1]
        
        return root
    }
}
