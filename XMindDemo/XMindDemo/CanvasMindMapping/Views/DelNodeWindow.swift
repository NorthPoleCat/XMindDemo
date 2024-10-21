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
    
    init(delId: String) {
        self.delId = delId
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
                let root = CommonUtils.shared.getData(for: .canvas)
                //这里的设计不好，更好的方式是能同时获取del 和 parent，但是这里暂时先如此实现
                let del = root.getNode(by: [delId])
                root.del(id: delId)
                RefreshTrigger.shared.refresh()
                dismiss()
            } label: {
                Text("Option 1")
            }
            
            Button {
                let root = CommonUtils.shared.getData(for: .canvas)
                root.del(id: delId, fullDel: false)
                RefreshTrigger.shared.refresh()
                dismiss()
            } label: {
                Text("Option 2")
            }
            
            Spacer()
        }
    }
}
