//
//  Node.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/17.
//

import Foundation

class Node: Codable {
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
    
    func copy(from node: Node) {
        title = node.title
        content = node.content
    }
    
    func getNodes(by id: [String]) -> [Node] {
        var stack: [Node] = [self]
        var result: [Node] = []
        
        while !stack.isEmpty && result.count < id.count {
            let currentNode = stack.removeLast()
            if id.contains(currentNode.id) {
                result.append(currentNode)
            }

            for child in currentNode.children {
                stack.append(child)
            }
        }
        return result
    }
    
    func getNode(by id: String) -> Node? {
        if (self.id == id) {
            return self
        } else {
            for child in children {
                return child.getNode(by: id)
            }
        }
        return nil
    }
    
    // return value: true for replace succeed
    func replace(with node: Node) -> Bool {
        if (id == node.id) {
            copy(from: node)
            return true
        } else {
            for child in children {
                if child.replace(with: node) {
                    return true
                }
            }
        }
        return false
    }
    
    func add(parentId: String, node: Node) {
        if (id == parentId) {
            node.parent = id
            children.append(node)
            return
        } else {
            for child in children {
                child.add(parentId: parentId, node: node)
            }
        }
    }
    
    func del(id: String, parent: Node, fullDel: Bool = true) {
        if self.id == id {
            if isRoot() {
                //当前逻辑不支持删除root节点
                return
            }
            
            if !fullDel {
                parent.children.append(contentsOf: children)
            }
            
            parent.children = parent.children.filter { $0.id != id }
            self.parent = ""
            
        } else {
            for child in children {
                child.del(id: id, parent: parent, fullDel: fullDel)
            }
        }
    }
    
    func isRoot() -> Bool {
        parent == ""
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
        let root = Node()
        root.title = "Root"
        
        let child1 = Node()
        child1.title = "Child1"
        child1.parent = root.id
        
        let child11 = Node()
        child11.title = "processes in a system share the CPU and main memory with other processes. However, sharing the main memory poses some special challenges."
        child11.parent = child1.id
        
        let child12 = Node()
        child12.title = "Error Handling"
        child12.parent = child1.id
        
        child1.children = [child11, child12]
        
        let child2 = Node()
        child2.title = "Let us define the operation +uw for arguments x and y, where 0 ≤ x, y < 2w, as the result of truncating the integer sum x + y to be w bits long and then viewing the result as an unsigned number. This can be characterized as a form of modular arithmetic, computing the sum modulo 2w by simply discarding any bits with weight greater than 2w−1 in the bit-level representation of x + y."
        child2.parent = root.id
        
        let child3 = Node()
        child3.title = "Child3"
        child3.parent = root.id
        
        root.children = [child1, child2, child3]
        
        return root
    }
}
