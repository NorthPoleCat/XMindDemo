//
//  WebViewWrapper.swift
//  ProgressDash
//
//  Created by xun liu on 2023/4/7.
//

import SwiftUI
import WebKit

struct WebViewWrapper: NSViewRepresentable {
    @Environment(\.openWindow) private var openWindow
    @EnvironmentObject private var refresh: RefreshTrigger
        
    func makeCoordinator() -> MessageHandler {
        MessageHandler(openWindow: openWindow)
    }
    
    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.userContentController.add(context.coordinator, name: "load")
        configuration.userContentController.add(context.coordinator, name: "editNode")
        configuration.userContentController.add(context.coordinator, name: "addNode")
        configuration.userContentController.add(context.coordinator, name: "delNode")
        configuration.userContentController.add(context.coordinator, name: "dragNode")
        
        let webView =  WKWebView(frame: .zero, configuration: configuration)
        webView.isInspectable = true
        context.coordinator.webView = webView
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        guard let url = CommonUtils.shared.mindMapURL() else {
            return
        }
        nsView.loadFileURL(url, allowingReadAccessTo: url)
        context.coordinator.reloadMindMap()
    }
}

class MessageHandler: NSObject, WKScriptMessageHandler, WKUIDelegate {
    var webView: WKWebView = WKWebView()
    private var openWindow: OpenWindowAction

    init(openWindow: OpenWindowAction) {
        self.openWindow = openWindow
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let n = CommonUtils.shared.getData(for: .canvas)
        
        if message.name == "load" {
            let jsonString = n.rootJson()
            let escapedString = jsonString.replacingOccurrences(of: "\\", with: "\\\\")
                        .replacingOccurrences(of: "\"", with: "\\\"")
                        .replacingOccurrences(of: "'", with: "\\'")
                        .replacingOccurrences(of: "\n", with: "\\n")
                        .replacingOccurrences(of: "\r", with: "\\r")
                        .replacingOccurrences(of: "\t", with: "\\t")
                
            let JSResult = String(format: "loadData('%@')" , escapedString)
            webView.uiDelegate = self
            webView.evaluateJavaScript(JSResult)
        } else if message.name == "editNode" {
            guard let dict: Dictionary = message.body as? [String: String],
                  let id = dict["id"] else {
                return
            }
            let edit = Node(id: id, title: dict["title"] ?? "", content: dict["content"] ?? "")
            if n.replace(with: edit) {
                n.save(.canvas)
                reloadMindMap()
            }
        } else if message.name == "addNode" {
            guard let parentId: String = message.body as? String else { return }
            OpenWindows.AddNode.open(openAction: openWindow, param: parentId)
        } else if message.name == "delNode" {
            guard let dict: Dictionary = message.body as? [String: String],
                    let id = dict["id"],
                    let parent = dict["parent"] else {
                return
            }
            OpenWindows.DelNode.open(openAction: openWindow, param: id + ":" + parent)
        } else if message.name == "dragNode" {
            guard let dict: Dictionary = message.body as? [String: String],
                    let start = dict["start"],
                    let end = dict["end"],
                    let parent = dict["parent"] else {
                return
            }
            OpenWindows.Drag.open(openAction: openWindow, param: start + ":" + end + ":" + parent)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        DispatchQueue.main.async {
            OpenWindows.Alert.open(openAction: self.openWindow, param: message)
        }
    }
    
    func reloadMindMap() {
        let n = CommonUtils.shared.getData(for: .canvas)
        n.save(.canvas)
        let jsonString = n.rootJson()
        let escapedString = jsonString.replacingOccurrences(of: "\\", with: "\\\\")
                    .replacingOccurrences(of: "\"", with: "\\\"")
                    .replacingOccurrences(of: "'", with: "\\'")
                    .replacingOccurrences(of: "\n", with: "\\n")
                    .replacingOccurrences(of: "\r", with: "\\r")
                    .replacingOccurrences(of: "\t", with: "\\t")
            
        let JSResult = String(format: "loadData('%@')" , escapedString)
        webView.evaluateJavaScript(JSResult)
        webView.reload()
    }
}
