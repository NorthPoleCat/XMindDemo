//
//  DragNodeWindow.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/22.
//

import SwiftUI

struct DragNodeWindow: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var movingStatus: MoveStatus = .notMoving
    
    private var start: String
    private var end: String
    private var parent: String
    
    init(_ dictString: String) {
        let params = dictString.split(separator: ":").map { String($0) }
        if params.count < 3 {
            self.start = ""
            self.end = ""
            self.parent = ""
            return
        }
        self.start = params[0]
        self.end = params[1]
        self.parent = params[2]
    }
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 15) {
                Text("本Demo一共提供以下两种拖拽方式：")
                    .font(.title2)
                Text("1. 拖拽该节点和其下所有子节点")
                Text("2. 仅拖拽该节点，该节点下的子节点归属该节点的父节点")
            }
            .padding()
            
            Button {
                let root = CommonUtils.shared.getData(for: .canvas)
                guard let end = root.getNode(by: end),
                        let startParent = root.getNode(by: parent) else { return }
                movingStatus = root.move(startId: start, end: end, parent: startParent)
                root.save(.canvas)
                RefreshTrigger.shared.refresh()
                dismiss()
            } label: {
                Text("Option 1")
            }
            
            Button {
                let root = CommonUtils.shared.getData(for: .canvas)
                guard let end = root.getNode(by: end),
                      let startParent = root.getNode(by: parent) else { return }
                movingStatus = root.move(startId: start, end: end, parent: startParent, fullRemove: false)
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
