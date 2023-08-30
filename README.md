# **Implement Vuukle SDK for iOS**

1. From **Project Navigator** pane Select you project -> Select your project in the left pane (not target) -> Select **Package Dependencies** tab

2. Enter `https://github.com/vuukle/ios-widgets-vuukle.git` URL in search field on top right corner.

3. Select `Up To Next Major Version` and select version `1.1.3`

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

8. Load the Vuukle view by using the `vuukleManager.load` function, passing in the necessary parameters as shown below:

   ```swift
   vuukleManager.load(on: vuukleView, url: URL(string: "{vuukle_widget_uri}")!)
   ```
   
   The `vuukle_widget_uri` parameter should be replaced with one of the following values, corresponding to the desired Vuukle platform:
   
   • **Quizzly Platform**: Enable quizzes and interactive content.
   
   URI: `https://cdn.vuukle.com/amp-quiz.html`
   
   • **Commenting Platform**: Enable a commenting system for user engagement.
   
   URI: `https://cdn.vuukle.com/amp.html`
   
   • **Reactions (Emotes) Platform**: Allow users to express their reactions to content.
   
   URI: `https://cdn.vuukle.com/amp-emotes.html`
   
   • **Social Share Bar Platform**: Integrate social media sharing functionality.
   
   URI: `https://cdn.vuukle.com/amp-sharebar.html`
   
   When loading the view, make sure to incorporate the following dynamic query parameters into the URI:
   
   • `{HOST}`: Your domain name without "www." or "https://" (e.g., example.com).
   
   • `{CANONICAL_URL}`: The canonical URL of the page.
   
   • `{ARTICLE_ID}`: Unique alphanumeric ID for the article page.
   
   • `{APIKEY}`: Your Vuukle API key, which can be found in your Vuukle dashboard.
   
   • `{ARTICLEIMAGEURL}`: Link to the article's image.
   
   • `{ARTICLE_TITLE}`: The title of the article.
   
   For instance, the URI with dynamic parameters could look like this:
   
   ```swift
   https://cdn.vuukle.com/amp-quiz.html?url=CANONICAL_URL&host=HOST&id=ARTICLE_ID&apiKey=YOUR_APIKEY&title=ARTICLE_TITLE&img=ARTICLE_IMAGE
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
```

See full list in  `NewEventListener` class.

