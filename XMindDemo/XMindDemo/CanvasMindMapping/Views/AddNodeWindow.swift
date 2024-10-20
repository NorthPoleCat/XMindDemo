//
//  AddNodeWindow.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/20.
//

import SwiftUI

struct AddNodeWindow: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    
    private var parentId: String
    
    init(parentId: String) {
        self.parentId = parentId
    }
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                Title("Title")
                TextField("", text: $title)
                Title("Content")
                TextEditor(text: $content)
            }
            .padding()
            
            HStack(alignment: .center) {
                Button {
                    var addNode = Node.defaultNode
                    addNode.title = title
                    addNode.content = content
                    
                    var root = CommonUtils.shared.getData(for: .canvas)
                    _ = root.add(parentId: parentId, node: addNode)
                    root.save(.canvas)
                    dismiss()
                } label: {
                    Title("Save")
                }
                
                Button {
                    dismiss()
                } label: {
                    Title("Cancel")
                }

            }
            .padding(.bottom)
        }
    }
    
    func Title(_ text: String) -> some View {
        Text(text)
            .frame(alignment: .leading)
            .font(.headline)
            .padding(.vertical, 5)
    }
}
