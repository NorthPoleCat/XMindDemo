//
//  Node.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/17.
//

import Foundation

struct Node: Codable {
    static var defaultNode = getDefaultNode()
    static var none: Node {
        get {
            Node()
        }
    }
    
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
    
    init(id: String, title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
    
    mutating func copy(from node: Node) {
        title = node.title
        content = node.content
    }
    
    // return value: true for replace succeed
    mutating func replace(with node: Node) -> Bool {
        if (id == node.id) {
            copy(from: node)
            return true
        } else {
            for i in 0..<children.count {
                if children[i].replace(with: node) {
                    return true
                }
            }
        }
        return false
    }
    
    mutating func add(parentId: String, node: Node) {
        if (id == parentId) {
            children.append(node)
            return
        } else {
            for i in 0..<children.count {
                children[i].add(parentId: parentId, node: node)
            }
        }
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
        
        var child11 = Node()
        child11.title = "processes in a system share the CPU and main memory with other processes. However, sharing the main memory poses some special challenges."
        
        var child12 = Node()
        child12.title = "Error Handling"
        
        child1.children = [child11, child12]
        
        var child2 = Node()
        child2.title = "Let us define the operation +uw for arguments x and y, where 0 ≤ x, y < 2w, as the result of truncating the integer sum x + y to be w bits long and then viewing the result as an unsigned number. This can be characterized as a form of modular arithmetic, computing the sum modulo 2w by simply discarding any bits with weight greater than 2w−1 in the bit-level representation of x + y."
        
        var child3 = Node()
        child3.title = "Child3"
        
        root.children = [child1, child2, child3]
        
        return root
    }
}
