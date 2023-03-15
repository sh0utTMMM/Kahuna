//
//  LiveStreamView.swift
//  Kahuna
//
//  Created by Connor McClanahan on 15/03/2023.
//
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
}

struct YoutubePlayerView: View {
    var body: some View {
        WebView(url: URL(string: "https://www.youtube.com/embed/EHKOx5QJEj4?controls=1&showinfo=0")!)
            .frame(width: 560, height: 315)
    }
}


