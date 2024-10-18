//
//  MindMapView.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/17.
//

import SwiftUI

struct MindMapView: View {
    @State private var position: CGSize = .zero
    var node: Node
        
    var body: some View {
        ZStack {
            Text(node.title)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
                .offset(position)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.position = value.translation
                        }
                )
            
            LineView(start: CGPoint(x: 50, y: 50), end: CGPoint(x: 150, y: 150))
        }
        .frame(width: 100)
        .frame(minHeight: 0, maxHeight: .infinity)
            
        ForEach(node.children, id: \.id) { childNode in
            MindMapView(node: childNode)
                .padding(.leading, 100)
                .padding(.top, 15)
        }
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
