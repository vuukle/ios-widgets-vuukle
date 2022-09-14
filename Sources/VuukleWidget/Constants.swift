//
//  Constants.swift
//  Vuukle
//
//  Created by Garnik Ghazaryan on 25.03.22.
//

import Foundation

struct Constants {
    static let encodedTokenKey = "encodedTokenKey"
    enum JavaScriptSnippet: String {
        case preventScaling = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"
        case logCapturer = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
    }
}
