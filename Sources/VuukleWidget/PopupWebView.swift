//
//  PopupWebView.swift
//  Vuukle
//
//  Created by Narek Dallakyan on 23.03.22.
//

import Foundation
import UIKit
import WebKit

class PopupView: UIView, WebViewable {

     lazy var webView = BaseWebView(frame: bounds)

    var closeButtonTapped: ((PopupView) -> Void)?

    private let url: URL
    
    private let wkWebView: WKWebView

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(closeButtonTapped(_ :)), for: .touchUpInside)
        button.backgroundColor = .clear
        let image = UIImage(named: "ic_close_circle", in: Bundle.module, compatibleWith: nil)
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    
    init(withURL: URL, navDelegate: WKNavigationDelegate? = nil, uiDelegate: WKUIDelegate? = nil, configuration: WKWebViewConfiguration) {
        print("PopupView: init")
        url = withURL
        self.wkWebView = BaseWebView(frame: .zero, configuration: configuration)
        super.init(frame: .zero)
        self.wkWebView.navigationDelegate = navDelegate
        self.wkWebView.uiDelegate = uiDelegate
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = .white
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addCornerRadiusAndShadow(cornerRadius: 8, shadowColor: .black, shadowOffset: CGSize(width: -3, height: -5), shadowRadius: 10, shadowOpacity: 0.8)
        if !self.wkWebView.isDescendant(of: self) {
            self.wkWebView.frame = bounds
            addWebView()
            addCloseButton()
        }
    }

    // MARK: - Private

    private func addWebView() {
        self.wkWebView.frame = bounds
        addSubview(self.wkWebView)
        self.wkWebView.load(URLRequest(url: url))
    }

    private func addCloseButton() {
        addSubview(closeButton)
        closeButton.frame = CGRect(x: bounds.size.width - 66, y: 10, width: 66, height: 66)
    }

//    private func editURL(_ url: URL) -> URL {
//        var mutableURL = url
//        if self.wkWebView.isDarkModeEnabled {
//            mutableURL.removeParam(name: "darkMode")
//            mutableURL.appendParam(name: "darkMode", value: "true")
//        }
//        return mutableURL
//    }

    // MARK: - Actions

    @objc func closeButtonTapped(_ sender: Any) {
        closeButtonTapped?(self)
        removeFromSuperview()
    }
}
