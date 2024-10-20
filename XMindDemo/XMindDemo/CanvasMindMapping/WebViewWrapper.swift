//
//  WebViewWrapper.swift
//  ProgressDash
//
//  Created by xun liu on 2023/4/7.
//

import SwiftUI
import WebKit

struct WebViewWrapper: NSViewRepresentable {
    let url: URL?
    let node: Node
        
    func makeCoordinator() -> MessageHandler {
        MessageHandler()
    }
    
    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.userContentController.add(context.coordinator, name: "load")
        configuration.userContentController.add(context.coordinator, name: "nodeClick")
        configuration.userContentController.add(context.coordinator, name: "editNode")
        configuration.userContentController.add(context.coordinator, name: "addNode")
        configuration.userContentController.add(context.coordinator, name: "delNode")
        
        let webView =  WKWebView(frame: .zero, configuration: configuration)
        webView.isInspectable = true
        context.coordinator.webView = webView
        context.coordinator.node = node
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        guard let url = url else {
            return
        }
        nsView.loadFileURL(url, allowingReadAccessTo: url)
    }
}

class MessageHandler: NSObject, WKScriptMessageHandler, WKUIDelegate {
    var webView: WKWebView = WKWebView()
    var node: Node?

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        guard var n = node else { return }
        
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
        } else if message.name == "nodeClick" {
            
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

        } else if message.name == "delNode" {
            
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        print(message)
    }
    
    func reloadMindMap() {
        node = CommonUtils.shared.getData(for: .canvas)
        guard let n = node else { return }
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
