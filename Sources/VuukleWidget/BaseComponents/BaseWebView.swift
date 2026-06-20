//
//  BaseWebView.swift
//  Vuukle
//
//  Created by Narek Dallakyan on 11.05.22.
//  Modified 2026-06: replaced fatalError in init?(coder:) to support storyboard/xib loading.
//

import Foundation
import WebKit

class BaseWebView: WKWebView {

    var isDarkModeEnabled: Bool = false

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        customUserAgent = VuukleConstants.httpUserAgent.rawValue
    }

    // Required for storyboard/xib instantiation. Previously crashed with fatalError.
    // Publishers using Interface Builder to place a VuukleView would hit this path.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customUserAgent = VuukleConstants.httpUserAgent.rawValue
    }

    @discardableResult
    override func load(_ request: URLRequest) -> WKNavigation? {
        var urlRequest = request
        urlRequest.setValue(VuukleConstants.httpUserAgent.rawValue,
                         forHTTPHeaderField: "User-Agent")
        return super.load(urlRequest)
    }
}
