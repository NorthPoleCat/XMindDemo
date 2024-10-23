//
//  ContentView.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/17.
//

import SwiftUI

struct ContentView: View {
    @State var currentType: MindType = .canvas
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(MindType.allCases, id: \.self) { type in
                    listRow(type)
                }
            }
        } detail: {
//            Text("test native")
            mindView
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    private func listRow(_ mindType: MindType) -> some View {
        HStack {
            Text(mindType.rowTitle())
            Spacer()
        }
        .padding(5)
        .onTapGesture {
            currentType = mindType
        }
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(currentType == mindType ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
    
    @ViewBuilder
    private var mindView: some View {
        switch currentType {
        case .canvas:
            WebViewWrapper()
        case .native:
            ScrollView([.horizontal, .vertical]) {
                MindMapView(node: CommonUtils.shared.getData(for: .native))
            }
        case .cmaker:
            Text("test3")
        }
    }
}
