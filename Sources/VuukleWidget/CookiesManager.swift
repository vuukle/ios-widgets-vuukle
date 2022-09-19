//
//  CookiesManager.swift
//  Vuukle
//
//  Created by Narek Dallakyan on 29.05.22.
//

import Foundation
import UIKit
import WebKit

class CookiesManager {

    private let cookieTokenKey = "cookieTokenKey"
    private let cookieNameToken = "vuukle_token"

    private let cookieDomains = [".vuukle.com", "vuukle.com", "https://news.vuukle.com", "https://dash.vuukle.com"]

    private var registeredViews: [WebViewable] = []

    init() {
        Utils.addUniqueObserver(observer: self, selector: #selector(lifeCycleEvent(_:)), name: UIApplication.willTerminateNotification, object: nil)
        Utils.addUniqueObserver(observer: self, selector: #selector(lifeCycleEvent(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        Utils.addUniqueObserver(observer: self, selector: #selector(lifeCycleEvent(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc func lifeCycleEvent(_ notification: Notification) {
        DispatchQueue.main.async {
            switch notification.name {
            case UIApplication.didEnterBackgroundNotification:
                self.didEnterBackground()
            case UIApplication.willTerminateNotification:
                self.willTerminate()
            case UIApplication.didBecomeActiveNotification:
                self.didBecomeActive()
            default:
                break
            }
        }
    }

    func registerViewInStorage(view: WebViewable) {
        self.registeredViews.append(view)
    }

    // MARK: - Private functions

    private func didEnterBackground() {
        saveTokenCookies()
    }

    private func willTerminate() {
        saveTokenCookies()
    }

    /*
    private func didBecomeActive() {
        guard let token = Utils.UserDefaultsManager.getValue(for: cookieTokenKey) else { return }
        cookieDomains.forEach { domain in
            if let cookie = HTTPCookie(properties: [.version:1, .name: cookieNameToken, .value: token, .domain: domain, .path:"/", .secure: true]) {
                WKWebsiteDataStore.default().httpCookieStore.setCookie(cookie)
            }
        }
    }

    private func saveTokenCookies() {
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
            if !cookies.contains(where: { $0.name == self.cookieNameToken }) {
                Utils.UserDefaultsManager.removeValue(for: self.cookieTokenKey)
                return
            }
            cookies.forEach { cookie in
                if cookie.name == self.cookieNameToken {
                    Utils.UserDefaultsManager.saveValue(string: cookie.value, key: self.cookieTokenKey)
                }
            }
        }
    }
    */

    private func didBecomeActive() {
        guard let vuukleTokenValue = Utils.UserDefaultsManager.getValue(for: cookieTokenKey) else { return }
        registeredViews.forEach { view in
            view
                .webView
                .evaluateJavaScript("window.localStorage.setItem('vuukle_token', '\(vuukleTokenValue)')") { result, error in
                    print(result ?? error ?? "Unknown")
                }
        }
    }

    private func saveTokenCookies() {
        registeredViews.forEach({ view in
            view
                .webView
                .evaluateJavaScript("window.localStorage.getItem('\(cookieNameToken)')", completionHandler: { result, error in
                    if let token = result as? String {
                        Utils.UserDefaultsManager.saveValue(string: token, key: self.cookieTokenKey)
                    }
                })
        })
    }
}
