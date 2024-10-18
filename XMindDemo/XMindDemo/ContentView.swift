//
//  ContentView.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/17.
//

import SwiftUI

struct ContentView: View {
    @State var currentType: MindType = .native
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
        Text(mindType.rowTitle())
            .onTapGesture {
                currentType = mindType
            }
    }
    
    @ViewBuilder
    private var mindView: some View {
        switch currentType {
        case .canvas:
            WebViewWrapper(url: CommonUtils.shared.mindMapURL(),
                           node: CommonUtils.shared.getData(for: currentType))
        case .native:
            ScrollView([.horizontal, .vertical]) {
                MindMapView(node: CommonUtils.shared.getData(for: currentType))
            }
        case .cmaker:
            Text("test3")
        }
    }
}
