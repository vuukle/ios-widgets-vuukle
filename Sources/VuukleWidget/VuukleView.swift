//
//  VuukleView.swift
//  Vuukle
//
//  Created by Garnik Ghazaryan on 19.03.22.
//

import MessageUI
import UIKit
import WebKit

protocol WebViewable {
    var webView: BaseWebView { get }
}

public class VuukleView: UIView, WebViewable {

    public var isDarkModeEnabled: Bool = false {
        didSet {
            webView.isDarkModeEnabled = isDarkModeEnabled
        }
    }

    var webNavigationDelegate: WKNavigationDelegate?
    var webUIDelegate: WKUIDelegate?

    lazy var webView = BaseWebView(frame: bounds)

    var logoutEventListener: (() -> Void)?

    init() {
        super.init(frame: .zero)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if !webView.isDescendant(of: self) {

            webView.navigationDelegate = webNavigationDelegate
            webView.uiDelegate = webUIDelegate
            webView.frame = bounds
            addSubview(webView)
            let script = WKUserScript(source: Constants.JavaScriptSnippet.logCapturer.rawValue, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            webView.configuration.userContentController.addUserScript(script)
            // register the bridge script that listens for the output
            webView.configuration.userContentController.add(self, name: "logHandler")
        }
    }

    // MARK: - Private and internal functions

    func loadURL(url: URL) {
        let request = URLRequest(url: editURL(url))
        webView.load(request)
    }

    private func setupView() {}

    func reloadForSSOLogin(token: String) {
        guard var url = webView.url else { return }
        url.appendParam(name: "sso", value: "true")
        url.appendParam(name: "loginToken", value: "\(token)")
        webView.load(URLRequest(url: url))
    }

    func reloadForLogout() {
        guard var url = webView.url else { return }
        url.removeParams(names: ["sso", "loginToken"])
        clearAllCookies()

        webView.load(URLRequest(url: url))
    }

    func reloadWebView() {
        webView.reload()
    }

    private func clearAllCookies() {
        for cookie in HTTPCookieStorage.shared.cookies ?? [] {
             HTTPCookieStorage.shared.deleteCookie(cookie)
         }
         /// URL cache
         URLCache.shared.removeAllCachedResponses()
         /// WebKit cache
         let date = Date(timeIntervalSince1970: 0)
         WKWebsiteDataStore.default().removeData(
             ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
             modifiedSince: date,
             completionHandler:{})
    }

    private func editURL(_ url: URL) -> URL {
        var mutableURL = url
        if webView.isDarkModeEnabled {
            mutableURL.removeParam(name: "darkMode")
            mutableURL.appendParam(name: "darkMode", value: "true")
        }
        return mutableURL
    }
}

extension VuukleView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let body = message.body as? String, body.contains(VuukleConstants.logoutClickedMessage.rawValue) {
            logoutEventListener?()
        }
    }
}
