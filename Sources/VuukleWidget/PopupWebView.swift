//
//  PopupWebView.swift
//  Vuukle
//
//  Created by Garnik Ghazaryan on 23.03.22.
//

import Foundation
import UIKit
import WebKit

class PopupView: UIView, WebViewable {

    lazy var webView = BaseWebView(frame: bounds)

    var closeButtonTapped: ((PopupView) -> Void)?

    private let url: URL

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(closeButtonTapped(_ :)), for: .touchUpInside)
        button.backgroundColor = .clear
        let image = UIImage(named: "ic_close_circle", in: Bundle.module, compatibleWith: nil)
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    
    init(withURL: URL, navDelegate: WKNavigationDelegate? = nil, uiDelegate: WKUIDelegate? = nil) {
        url = withURL
        super.init(frame: .zero)
        webView.navigationDelegate = navDelegate
        webView.uiDelegate = uiDelegate
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
        if !webView.isDescendant(of: self) {
            webView.frame = bounds
            addWebView()
            addCloseButton()
        }
    }

    // MARK: - Private

    private func addWebView() {
        webView.frame = bounds
        addSubview(webView)
        webView.load(URLRequest(url: editURL(url)))
    }

    private func addCloseButton() {
        addSubview(closeButton)
        closeButton.frame = CGRect(x: bounds.size.width - 66, y: 10, width: 66, height: 66)
    }

    private func editURL(_ url: URL) -> URL {
        var mutableURL = url
        if webView.isDarkModeEnabled {
            mutableURL.removeParam(name: "darkMode")
            mutableURL.appendParam(name: "darkMode", value: "true")
        }
        return mutableURL
    }

    // MARK: - Actions

    @objc func closeButtonTapped(_ sender: Any) {
        closeButtonTapped?(self)
        removeFromSuperview()
    }
}
