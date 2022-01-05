# Gist for iOS & iPadOS
Gist gives you access to a library of ready built micro-experiences that can be easily dropped into your application without writing a line of code.

## Installation

### Cocoapods
```ruby
pod 'Gist', '~> 2.1.2'
```

### SPM
```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://gitlab.com/bourbonltd/gist-apple.git", upToNextMinor: "2.1.2")
    ],
    ...
)
```

## Setup
In your `AppDelegate` add Gist as a stored property and initialize it inside the application’s `didFinishLaunchingWithOptions` method.

- The `organizationId` property can be retrieved from the Gist dashboard.
- Logging is optional.

```swift
func application(_ application: UIApplication, 
                  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Gist.shared.setup(organizationId: "your-organization-id", logging: true)

        return true
}
```

### User Token
If your app is relying on Gist’s web hook service to trigger in-app messages, a user token must be set. This user token should be generated by your services and set at any point during runtime, ex: login or registration.

```swift
Gist.shared.setUserToken("unique-user-token")
```

To clear the user token:
```swift
Gist.shared.clearUserToken()
```

### Setting Your Current Route
Gist is able to show messages when a user reaches a particular route within your product. This is completely optional but messages containing route rules will not be displayed.

In your route handler add:
```swift
Gist.shared.setCurrentRoute("user/profile")
```

## Broadcasts
Broadcasts enable you to receive messages based on topics the client is subscribed to.

### Subscribing
```swift
Gist.shared.subscribeToTopic("announcements")
```

### Unsubscribing
```swift
Gist.shared.unsubscribeFromTopic("announcements")
```

### Clear All Topics
```swift
Gist.shared.clearTopics()
```

## Manually Triggering In-App Messages
Gist gives you the option to programmatically trigger in-app messaging flows within your app.

### Show Message
```swift
let message = Message(messageId: "message-id")
Gist.shared.showMessage(message, position: .center)
```

Note that every message object creates a unique `instanceId` which can be used as a reference when an action occurs.

### Adding Message Properties
```swift
message.addProperty(key: "property-key", value: "Hello")
```
Note: Properties also support `Encodable` objects

### Dismiss Message
```swift
Gist.shared.dismissMessage(message.instanceId)
```
With optional completion handler.

These methods should only be used to trigger flows programmatically, if you wish to create an integration with a custom CRM, see Integrations section below.

## Embedding
Gist gives you the option to embed a message within your native product. Calling `getMessageView` will return a `GistView`. Actions performed within the view are reported back to the `GistDelegate` delegate and `GistExtenable` extensions.

```swift
let message = Message(messageId: "message-id")
let view = Gist.shared.getMessageView(message)
```

## Event Handling
The framework exposes a delegate which you can hook into, this gives you the option to know when a message is shown, dismissed or when an action occurs within the message.

```swift
public protocol GistDelegate: AnyObject {
    func messageShown(message: Message)
    func messageDismissed(message: Message)
    func messageError(message: Message)
    func action(message: Message, currentRoute: String, action: String)
    func embedMessage(message: Message, elementId: String)
}
```

Whenever a message is queued for embedding, the event `embedMessage` is triggered. This leaves it up to the developer to decide where to place the view.

Embedded Gist views also expose their own delegate `GistViewDelegate`.

```swift
public protocol GistViewDelegate: AnyObject {
    func action(message: Message, currentRoute: String, action: String)
    func sizeChanged(message: Message, width: CGFloat, height: CGFloat)
}
```
