//
//  MindMapView.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/17.
//

import SwiftUI

struct MindMapView: View {
    @State private var offset: CGSize = .zero    // 当前的位移
    @State private var lastOffset: CGSize = .zero // 拖动结束后的位移
    var node: Node
        
    var body: some View {
        ZStack {
            Text(node.title)
                .padding()
                .frame(width: 100, height: 40)
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
                .offset(offset)
                .gesture(dragGesture)
            
//            LineView(start: CGPoint(x: 50, y: 20), end: CGPoint(x: 150, y: 150))
        }
            
        ForEach(node.children.indices, id: \.self) { index in
            MindMapView(node: node.children[index])
                .padding(.leading, 350)
                .padding(.top, calculateOffset(parentNode: node, index: index))
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                self.offset = CGSize(width: value.translation.width + self.lastOffset.width,
                                     height: value.translation.height + self.lastOffset.height)
            }
            .onEnded { _ in
                self.lastOffset = self.offset
            }
    }
    
    private func calculateOffset(parentNode: Node, index: Int) -> CGFloat {
        let offsetCount = CGFloat(parentNode.children.count - 1)
        let offsets: [CGFloat] = Array(stride(from: 0, through: offsetCount * 55, by: 55))
        let childrenTotalHeight = offsets.last! - offsets.first! + 40 //40 for static node height
        return offsets[index] - childrenTotalHeight * 0.5 - 40
    }
}

struct LineView: View {
    var start: CGPoint
    var end: CGPoint
    
    var body: some View {
        Path { path in
            path.move(to: start)
            path.addLine(to: end)
        }
        .stroke(Color.gray, lineWidth: 2)
    }
}
