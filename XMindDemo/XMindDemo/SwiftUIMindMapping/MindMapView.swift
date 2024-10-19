//
//  MindMapView.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/17.
//

import SwiftUI

struct MindMapView: View {
    @State var offset: CGSize = .zero    // 当前的位移
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
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            self.offset = value.translation
//                        }
//                )
//                .gesture(dragGesture)
                        
            let startPoint = CGPoint(x: offset.width + 50, y: offset.height + 20)  // 父节点的中心点
            
            ForEach(node.children.indices, id: \.self) { index in
                
                let childOffsetY = calculateOffset(parentNode: node, index: index)

                let endPoint = CGPoint(x: 150 + offset.width, y: childOffsetY + offset.height + 20) // 子节点的中心点
                
                MindMapView(offset: CGSize(width: offset.width + 150, height: childOffsetY + offset.height), node: node.children[index])
                
                LineView(start: startPoint, end: endPoint)
                    .zIndex(-1)
            }
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
        let offsets: [CGFloat] = Array(stride(from: 0, through: offsetCount * 70, by: 70))
        let childrenTotalHeight = offsets.last! - offsets.first!
        return offsets[index] - childrenTotalHeight * 0.5
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
