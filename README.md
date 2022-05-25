# Saytv Chat Example iOS
App that is going to use the Saytv Chat library.

## Chat SDK

The Chat SDK is available on Swift Package Manager (SPM), to use it we are going to need to follow the next steps:

1. Add a package by selecting `File` → `Add Packages…` in Xcode’s menu bar.

2. Search for the SaytvChat Apple SDK using the repo's URL:
```console
https://davidgarcia93@bitbucket.org/square1/saytv_sdk_ios.git
```

3. Next, set the **Dependency Rule** to be `Up to Next Major Version` and specify `1.0.0` as the lower bound.

4. Then, select **Add Package**.

5. Choose the `SaytvChat` on the list of the products and click **Add Package**

6. The SDK is private so you are going to need a password (That Square1 is going to send you) to download and add it to the project

7. Use this import on every file you want to use the pod
```swift
import SaytvChat
```

## Firebase
The class that handles all the push notification behavior is `PushComponent`. We assume you already have the **firebase configured**.

You need to instantiate the class and use the next methods in the **AppDelegate.swift**:

- Just after the personal app’s firebase configuration method in the `applicationDidFinishLaunchingWithOptions`, add `.configure()` to set up the SDK’s firebase configuration.

```swift
private let pushComponent = PushComponent()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        pushComponent.configure()
```

- After setting the delegate of the Messaging in the `applicationDidFinishLaunchingWithOptions`, add `.configureMessaging()` method to set up the SDK’s messaging

```swift
Messaging.messaging().delegate = self
pushComponent.configureMessaging()
```

- At the beginning of the `applicationDidReceiveRemoteNotification`, add the .`handlePush(response:_)` to filter the messages that the SDK is going to handle

```swift
func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if pushComponent.handlePush(response: userInfo) {
            completionHandler(.noData)
            return
        }
        // your code...
```

## Register and Login
To register inside the SDK you just need to add `SayTvSadk.register(digicelId:_, email:_, avatar:_, username:_, completion: _)` where the **completion** is going to have the service call response.

```swift
SayTvSdk.register(digicelId: 12,
                  email: "david2+saytv@square1.io",
                  avatar: "https://lorempixel.com/avatar.png",
                  username: "davidtwo") { result in
    switch result {
    case .success(let response):
        print(response)
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

To login inside the SDK, you just need to add `SayTvSdk.login(digicelId:_, completion: _)` where the completion is going to have the service call response

```swift
SayTvSdk.login(digicelId: digicelId) { result in
    switch result {
    case .success(let response):
        self.resultTextView.text = "Success: \(response == true), User has login"
    case .failure(let error):
        self.resultTextView.text = "Failure: \(error.localizedDescription)"
    }
}
```

## Chat
You are going to need to place an **UIView** anywhere you want on your screen, that will work as a container for the Chat that is going to show the chat screen, Once you have the **UIView** ready, you will have to call the `ChatComponent(`***view***`: _, name: _, image:_, startTime: _, endTime: _, `***chatId***`: _, theme: _, completion: _)`, where the ***view*** is the UIView that is configured in your screen, the others parameters are optional except for the ***chatId*** that you need to subscribe to the chat. The start time must be a date after or equal to now to work properly.

```swift 
class ChatViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    ...

    func startChat() {
        let name = "Nice episode event chat"
        let image = "https://image_url_example.com"
        let startTime = dateFormatter.date(from: "24/05/2022 10:05:00")
        let endTime = dateFormatter.date(from: "26/05/2022 18:00:00")
        let theme = ChatTheme(chatText: .red, 
                              chatTextPlaceholder: .orange,
                              chatTextBackground: .green, 
                              hashtagText: .green,
                              chatBackground: .darkGray, 
                              eventBackground: .cyan,
                              chatTextBorder: .blue)
        let _ = ChatComponent(view: containerView,
                              name: name,
                              image: image,
                              startTime: startTime,
                              endTime: endTime,
                              chatId: chatId,
                              theme: theme) { result in
            switch result {
            case .success:
                print("Chat Success")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    ...
}
```
