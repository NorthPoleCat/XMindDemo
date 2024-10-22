//
//  DelNodeWindow.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/21.
//

import SwiftUI

struct DelNodeWindow: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private var delId: String
    private var parentId: String
    
    init(_ dictString: String) {
        let params = dictString.split(separator: ":").map { String($0) }
        if params.count < 2 {
            self.delId = ""
            self.parentId = ""
            return
        }
        self.delId = params[0]
        self.parentId = params[1]
    }
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 15) {
                Text("本Demo一共提供以下两种删除方式：")
                    .font(.title2)
                Text("1. 删除该节点和其下所有子节点")
                Text("2. 仅删除该节点，该节点下的子节点归属该节点的父节点")
            }
            .padding()
            
            Button {
                if delId == "" || parentId == "" {
                    return
                }
                let root = CommonUtils.shared.getData(for: .canvas)
                guard let parent = root.getNode(by: parentId) else { return }
                root.del(id: delId, parent: parent)
                root.save(.canvas)
                RefreshTrigger.shared.refresh()
                dismiss()
            } label: {
                Text("Option 1")
            }
            
            Button {
                if delId == "" || parentId == "" {
                    return
                }
                let root = CommonUtils.shared.getData(for: .canvas)
                guard let parent = root.getNode(by: parentId) else { return }
                root.del(id: delId, parent: parent, fullDel: false)
                root.save(.canvas)
                RefreshTrigger.shared.refresh()
                dismiss()
            } label: {
                Text("Option 2")
            }
            
            Spacer()
        }
    }
}
