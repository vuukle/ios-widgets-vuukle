//
//  VuukleManager.swift
//  Vuukle
//
//  Created by Narek Dallakyan on 19.03.22.
//

import Foundation
import MessageUI
import UIKit
import WebKit

public struct PublisherKeyPair {
    public let privateKey: String
    public let publicKey: String

    public init(privateKey: String, publicKey: String) {
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
}

public class VuukleManager: NSObject {

    public var addErrorListener: ((VuukleExceptions) -> Void)?
    public var addSSOExceptionsListener: ((SSOExceptions) -> Void)?

    public lazy var newEvent = NewEventListener()

    private var viewController: UIViewController
    private var publisherKeyPair: PublisherKeyPair
    private var registeredViews: [VuukleView] = []
    private lazy var ssoAuthManager = SSOAuthManager(publisherKeyPair: publisherKeyPair)
    private let cookieManager = CookiesManager()

    public init(viewController: UIViewController, publisherKeyPair: PublisherKeyPair) {
        self.viewController = viewController
        self.publisherKeyPair = publisherKeyPair
    }

    public func load(on view: VuukleView, url: URL) {
        guard let newURL = ssoAuthManager.makeAuthentifiableIfNeeded(url: url) else { return }
        setupListeners(view: view)
        registeredViews.append(view)
        cookieManager.registerViewInStorage(view: view)

        view.webUIDelegate = self
        view.webNavigationDelegate = self

        view.loadURL(url: newURL)
    }

    public func ssoLogin(with email: String, username: String) {
        ssoAuthManager.login(email: email, username: username) { [weak self] token in
            self?.registeredViews.forEach { $0.reloadForSSOLogin(token: token) }
        }
    }

    public func ssoLogout() {
        ssoAuthManager.logout()
        registeredViews.forEach({ $0.reloadForLogout() })
    }

    // MARK: - Private funcs

    private func setupListeners(view: VuukleView) {

        ssoAuthManager.ssoExceptionsListener = { [weak self] error in
            self?.addSSOExceptionsListener?(error)
        }

        view.logoutEventListener = { [weak self] in
            self?.ssoLogout()
        }
    }

    private func openWebView(webView: WKWebView, withURL: URL, isDarkModeEnabled: Bool, configuration: WKWebViewConfiguration) -> WKWebView {
        let popupView = PopupView(frame: webView.frame, withURL: withURL, navDelegate: self, uiDelegate: self, configuration: configuration)
        popupView.webView.isDarkModeEnabled = isDarkModeEnabled
        cookieManager.registerViewInStorage(view: popupView)

        viewController.view.bringSubviewToFront(popupView)
        viewController.view.embed(view: popupView, insets: UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35))

        popupView.closeButtonTapped = { [weak self] mPopupView in
            self?.cookieManager.unRegisterViewInStorage(view: mPopupView)
            self?.registeredViews.forEach { $0.reloadWebView() }
        }
        
        return popupView.webView
    }

    private func openMail(urlString: String) {
        let mailSubjectBody = parseMailSubjectAndBody(mailto: urlString)
        sendEmail(subject: mailSubjectBody.subject, body: mailSubjectBody.body)
    }

    private func openAlert(prompt: String, defaultText: String, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            completionHandler(nil)
        }))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
            completionHandler(alertController.textFields?.first?.text)
        }))
        viewController.present(alertController, animated: true)
    }

    private func openNewWindow(webView: WKWebView, newURL: String, isDarkModeEnabled: Bool, configuration: WKWebViewConfiguration) -> WKWebView? {
        if newURL.contains(VuukleConstants.vuukleMailShare.rawValue) {
            openMail(urlString: newURL)
            return nil
        }

        if newURL.contains(VuukleConstants.vuukleFBMessengerShare.rawValue) {
            guard let messengerUrlString = newURL.removingPercentEncoding, let messengerUrl = URL(string: messengerUrlString) else { return nil }
            UIApplication.shared.open(messengerUrl)
            return nil
        }

        guard let url = URL(string: newURL) else { return nil }
        return openWebView(webView: webView, withURL: url, isDarkModeEnabled: isDarkModeEnabled, configuration: configuration)
    }

    private func pushNavigation(url: String) {
        let navigationController = BaseNavigationController(presentingViewController: viewController)

        let baseWebView = BaseWebView(frame: viewController.view.bounds)

        navigationController.mainViewController?.view.bringSubviewToFront(baseWebView)
        navigationController.mainViewController?.view.embed(view: baseWebView, insets: .zero)
        baseWebView.load(URLRequest(url: URL(string: url)!))
        if viewController.presentedViewController as? BaseNavigationController == nil {
            navigationController.show()
        }
    }
}

// MARK: - SEND EMAIL Methods
extension VuukleManager: MFMailComposeViewControllerDelegate {

    func sendEmail(subject: String, body: String) {
        let recipientEmail = ""
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            viewController.present(mail, animated: true)

        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            guard let newMailto = (emailUrl.absoluteString).removingPercentEncoding, let url = URL(string: newMailto) else { return }
            UIApplication.shared.open(url)
        }
    }

    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        guard let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }

        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }

        return defaultUrl
    }

    // Get Subject and Body from mailto url.
    func parseMailSubjectAndBody(mailto: String) -> (subject: String, body: String) {

        let newMailto = mailto.removingPercentEncoding ?? ""

        let subjectStartIndex = newMailto.firstIndex(of: "=")!
        let subjectEndIndex = newMailto.firstIndex(of: "&")!
        var subject = String(newMailto[subjectStartIndex..<subjectEndIndex])
        let bodyStartIndex = newMailto.lastIndex(of: "=")!
        var body = String(newMailto[bodyStartIndex...])
        subject.removeFirst()
        body.removeFirst()

        return (subject: subject, body: body)
    }

    // MARK: - MFMailComposeViewControllerDelegate
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension VuukleManager: WKNavigationDelegate, WKUIDelegate {

    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cred)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        addErrorListener?(.didFailProvisionalNavigation(error))
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        addErrorListener?(.failedToLoadURL(webView.url?.absoluteURL, error))
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("BASE URL Did Finish = \(webView.url?.absoluteString ?? "")")
        //TODO:  Remove popup after login -
        webView.evaluateJavaScript(Constants.JavaScriptSnippet.preventScaling.rawValue)
    }

    // MARK: - WKUIDelegate methods
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        openAlert(prompt: prompt, defaultText: defaultText ?? "", completionHandler: completionHandler)
    }

    @available(iOS 13.0, *)
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        if #available(iOS 14.0, *) {
            preferences.allowsContentJavaScript = true
        }

        guard let urlString = navigationAction.request.url?.absoluteString else { return }
        if urlString.contains(VuukleConstants.vuukleMailToShare.rawValue) {
            openMail(urlString: navigationAction.request.url?.absoluteString ?? "")
        }

        if urlString.lowercased().contains(VuukleConstants.external.rawValue) &&
            urlString.lowercased().contains(VuukleConstants.source.rawValue) {

            if urlString.contains(VuukleConstants.talkOfTown.rawValue) {
                if navigationAction.navigationType == .linkActivated { // Catch if URL is redirecting
                    if let talkOfTownListener = newEvent.talkOfTheTownListener {
                        talkOfTownListener(navigationAction.request.url)
                    } else {
                        openNewWindow(webView: webView, newURL: urlString, isDarkModeEnabled: (webView as? BaseWebView)?.isDarkModeEnabled ?? false, configuration: webView.configuration)
                    }
                decisionHandler(WKNavigationActionPolicy.cancel, preferences)
                return
                }
            }
        }

        decisionHandler(WKNavigationActionPolicy.allow, preferences)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let urlString = navigationAction.request.url?.absoluteString else { return nil }
        if urlString.lowercased().contains(VuukleConstants.external.rawValue) &&
            urlString.lowercased().contains(VuukleConstants.source.rawValue) {
            if urlString.contains(VuukleConstants.emoteRecommendations.rawValue) {
                if let whatsOnYourMind = newEvent.whatsOnYourMindListener {
                    if let range = urlString.range(of: "&url=") {
                        let urlStr = urlString[range.upperBound...]
                        if let url = URL(string: String(urlStr)) {
                            whatsOnYourMind(url)
                        }
                    }
                } else {
                    return openNewWindow(webView: webView, newURL: urlString, isDarkModeEnabled: (webView as? BaseWebView)?.isDarkModeEnabled ?? false, configuration: configuration)
                }
            }
        } else {
            return openNewWindow(webView: webView, newURL: urlString, isDarkModeEnabled: (webView as? BaseWebView)?.isDarkModeEnabled ?? false, configuration: configuration)
        }
        return nil
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        print("BASE URL did navigation = \(webView.url?.absoluteString ?? "")")
        if navigationAction.navigationType == .linkActivated { // Catch if URL is redirecting
            openNewWindow(webView: webView, newURL: navigationAction.request.url?.absoluteString ?? "",
                          isDarkModeEnabled: (webView as? BaseWebView)?.isDarkModeEnabled ?? false, configuration: webView.configuration)
            decisionHandler(.allow)
        } else if navigationAction.navigationType == .other {
            openNewWindow(webView: webView, newURL: navigationAction.request.url?.absoluteString ?? "",
                          isDarkModeEnabled: (webView as? BaseWebView)?.isDarkModeEnabled ?? false, configuration: webView.configuration)
        }
        decisionHandler(.allow)
    }
}
