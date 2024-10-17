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
    @Environment(\.openWindow) private var openWindow
        
    func makeCoordinator() -> MessageHandler {
        MessageHandler(openWindow: openWindow)
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
    private var openWindow: OpenWindowAction

    init(openWindow: OpenWindowAction) {
        self.openWindow = openWindow
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        guard let n = node else { return }
        
        if message.name == "load" {
            let jsonString = convertNodeToJSON(node: n)
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
//            guard let dict: Dictionary = message.body as? Dictionary<String, Any> else {
//                return
//            }
//            Node.resetSelect(dict: dict)
//            OpenWindows.MMNode.open()
            
//            UserDefaults.standard.set(mapData.stampId, forKey: "SelectedTarget")
//            selectedTarget.updateWithTarget(target: mapData.metaData)
        } else if message.name == "editNode" {
            guard let dict: Dictionary = message.body as? [String: Any] else {
                return
            }
            // 将消息体映射到自定义类型
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
                let decoder = JSONDecoder()
                let node = try decoder.decode(Node.self, from: jsonData)
            } catch {
                print("Failed to decode message: \(error)")
            }
        } else if message.name == "addNode" {

        } else if message.name == "delNode" {
            let alert = NSAlert()
            alert.messageText = "Alert"
            alert.informativeText = "Do you want to delete this task and its sub-tasks?"
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Cancel")
            alert.alertStyle = .warning
            // 获取当前主窗口或关键窗口
            if let window = NSApplication.shared.keyWindow ?? NSApplication.shared.mainWindow {
                alert.beginSheetModal(for: window) { response in
                    switch response {
                    case .alertFirstButtonReturn:
                        // OK按钮事件
                        break
                    case .alertSecondButtonReturn:
                        // Cancel按钮事件
                        print("Cancel button pressed")
                    default:
                        break
                    }
                }
            } else {
                // 如果没有窗口可用，直接显示警告对话框
                alert.runModal()
            }
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        print(message)
    }
    
    func convertNodeToJSON(node: Node) -> String {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(["root":node]) {
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        return ""
    }
}
