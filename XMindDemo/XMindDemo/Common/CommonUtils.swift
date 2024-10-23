//
//  CommonUtils.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/18.
//

import Foundation

class CommonUtils {
    static let shared = CommonUtils()
    
    var mindType: MindType = .canvas
    
    private var cleanCache: Bool = false
    
    func getData(for type: MindType) -> Node {
        if cleanCache {
            cleanCache = false
            return Node.defaultNode
        }
            
        guard let fileURL = CommonUtils.shared.getStorePath(type) else { return Node.defaultNode }
        
        do {
            let storeData = try Data(contentsOf: fileURL)
            let storeNote = try JSONDecoder().decode(Node.self, from: storeData)
            return storeNote
        } catch {
            print("Failed to read or decode file: \(error)")
        }
        
        return Node.defaultNode
    }
    
    func getStorePath(_ type: MindType) -> URL? {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(type.filePath())
    }
    
    func mindMapURL() -> URL? {
        guard let filePath = Bundle.main.path(forResource: "mindMapping", ofType: "html") else {
            return nil
        }
        
        return URL(fileURLWithPath: filePath)
    }
    
    func reset() {
        cleanCache = true
        RefreshTrigger.shared.refresh()
    }
}
