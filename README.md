# **Implement Vuukle SDK for iOS**

1. From **Project Navigator** pane Select you project -> Select your project in the left pane (not target) -> Select **Package Dependencies** tab

2. Enter `https://github.com/vuukle/ios-widgets-vuukle.git` URL in search field on top right corner.

3. Select `Up To Next Major Version` and select version `1.0.0`

4. Click `Add Package` button.

5. Import `Vuukle` to your `ViewController.swift` file 

   ````swift
   // Vuukle SDK
   import VuukleWidget
   ````

6. Initialize `VuukleManager` class passing viewcontroller and publisher key pairs

   ```swift
   let publisherKey = PublisherKeyPair(privateKey: "bd3a64e4-7e19-46b2-****-********",
                                        publicKey: "664e0b85-5b2c-4881-****-********")
   let vuukleManager = VuukleManager(viewController: self, publisherKeyPair: publisherKey)
   ```

7. Create views of type `VuukleView` (from xib, storyboard or programmatically) that should show content of your URLs

   ```swift
   let vuukleView = VuukleView()
   ```

8. Load url and pass view to show on like this:

   ```swift
   vuukleManager.load(on: vuukleView, url: URL(string: "https://help.vuukle.com/install-vuukle/how-to-integrate-vuukle-sdk-into-your-ios-app")!)
   ```

9. SSO Functionality
   For SSO login use:

   ```swift
   vuukleManager.ssoLogin(with: "test@gamil.com", username: "testUserName")
   ```

   For SSO logout use"

   ```swift
   vuukleManager.ssoLogout()
   ```

## **Setup Listeners**

#### Generic errors

Add error listeners using `public var addErrorListener: ((VuukleExceptions) -> Void)?`

```swift
vuukleManager.addErrorListener = { exception in
    switch exception {
    case .didFailProvisionalNavigation(let error):
        print("Error:", error)
    case .failedToLoadURL(let url, let error):
        print("URL and Error:", url, error)
    @unknown default:
        fatalError()
    }
}
```

See full list of exceptions in `VuukleExceptions` enum.

#### SSO Errors

Use `public var addSSOExceptionsListener: ((SSOExceptions) -> Void)?` to catch SSO login/logout exceptions 

```swift
vuukleManager.addSSOExceptionsListener = { exception in
    switch exception {
    case .emptyPublisherKeyPair(let message):
        print("Error Message:", message)
    case .authModelEncodingError(let error):
        print("Error", error)
    @unknown default:
        print("Other exceptions", exception)
    }
}
```

See full list of exceptions in `SSOExceptions` enum.

#### Webview Event listeners

Listen to events emitted from webview by adding listeners on `vuukleManager.newEvent`. If you did not set event listener, by default all events will be handled by `VuukleManager`

```swift
vuukleManager.newEvent.talkOfTheTownListener = { [weak self] url in
    print("talkOfTheTown URL - ", url)
}

vuukleManager.newEvent.whatsOnYourMindListener = { [weak self] url in
    print("whatsOnYourMind URL - ", url)
}

vuukleManager.newEvent.onSignInButtonClicked = { [weak self] in
    print("onSignInButtonClicked URL - ", "")
}
```

See full list in  `NewEventListener` class.
