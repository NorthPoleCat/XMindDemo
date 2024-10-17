//
//  ContentView.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            List {
                Text("js-Canvas")
                    .onTapGesture {
                        
                    }
                Text("native-swiftUI")
                Text("c render HTML")
                Spacer()
            }
        } detail: {
            Text("test")
        }

    }
}
