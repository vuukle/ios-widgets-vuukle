//
//  BaseWebView.swift
//  Vuukle
//
//  Created by Narek Dallakyan on 11.05.22.
//

import Foundation
import WebKit

class BaseWebView: WKWebView {

    var isDarkModeEnabled: Bool = false

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        customUserAgent = VuukleConstants.httpUserAgent.rawValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    override func load(_ request: URLRequest) -> WKNavigation? {
        var urlRequest = request
        urlRequest.setValue(VuukleConstants.httpUserAgent.rawValue,
                         forHTTPHeaderField: "User-Agent")
        return super.load(urlRequest)
    }
}
