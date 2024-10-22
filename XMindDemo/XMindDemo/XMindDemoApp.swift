//
//  XMindDemoApp.swift
//  XMindDemo
//
//  Created by xun liu on 2024/10/17.
//

import SwiftUI

@main
struct XMindDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(RefreshTrigger.shared)
        }
        
        WindowGroup(id: "AddNode", for: String.self) { $id in
            AddNodeWindow(parentId: id ?? "")
                .frame(width: 600, height: 400)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowToolbarStyle(.unified)
        .windowResizability(.contentSize)
        
        WindowGroup(id: "DelNode", for: String.self) { $id in
            DelNodeWindow(id ?? "")
                .frame(width: 400, height: 260)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowToolbarStyle(.unified)
        .windowResizability(.contentSize)
        
        WindowGroup(id: "Alert", for: String.self) { $msg in
            AlertView(message: msg ?? "")
                .frame(width: 200, height: 100)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowToolbarStyle(.unified)
        .windowResizability(.contentSize)
        
        WindowGroup(id: "Drag", for: String.self) { $id in
            DragNodeWindow(id ?? "")
                .frame(width: 400, height: 260)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowToolbarStyle(.unified)
        .windowResizability(.contentSize)
    }
}
