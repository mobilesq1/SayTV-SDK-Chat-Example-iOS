# Saytv Chat Example iOS
App that is going to use the Saytv Chat library.

Table of contents
- [what's New](#whats-new) 
- [Instalation](#chat-sdk)
- [Firebase](#firebase)
- [Initialisation](#initialisation)
- [Register and Login](#register-and-login)
- [Chat](#chat)
- [Known Issues](#known-issues)

## What's New
### 3.0.0
- Add SDK initialization with chat name .  
- Update chat theme:
    - make separate theme for chat component and header component,
    - add moderator chat message theme customization,
    - add chat options buttons customization.
- Improve SDK error handling.
- Display quiz results on chat list when enter the chat.
- Handle user banned status: On chat subscribe handle banned user error status and update chat UI: disable all option buttons and display message about banned user. 
- Refator chat options button to use native UIButton component with custom theme.
- Hide chat options buttons.
- Handle closed chat status: On chat subscribe handle closed chat error status and update chat UI: disable all option buttons and display infromation about closed chat.
- Replace system icons (play and keyboard icons) that are not supported below iOS 13.0.
- Fix chat filters gesture interaction.
- Fix chat input text field overlapped by chat message text.
- Fix chat remaining time date format.
- Update chat cell UI for moderator messages.
- Update chat layout in landscape mode - add spacing in chat messages and events when in horizontal mode.
- Add possibility to fetch active users list for selected chats.

## Chat SDK

The Chat SDK is available on Swift Package Manager (SPM), to use it we are going to need to follow the next steps:

1. Add a package by selecting `File` → `Add Packages…` in Xcode’s menu bar.

2. Search for the SaytvChat Apple SDK using the repo's URL:
```console
https://davidgarcia93@bitbucket.org/square1/saytv_sdk_ios.git
```

3. Next, set the **Dependency Rule** to be `Up to Next Major Version` and specify `2.0.0` as the lower bound.

4. Then, select **Add Package**.

5. Choose the `SaytvChat` on the list of the products and click **Add Package**

6. The SDK is private so you are going to need a password (That Square1 is going to send you) to download and add it to the project

7. Use this import on every file you want to use the pod
```swift
import SaytvChat
```

## Push notifications
The class that handles all the push notification behavior is `PushComponent`. We assume you already have the **push configured**.

You need to instantiate the class and use the next methods in the **AppDelegate.swift**:

```swift
private let pushComponent = PushComponent()
```

- At the beginning of the `applicationDidReceiveRemoteNotification`, add the `.handlePush(response:_)` to filter the messages that the SDK is going to handle

```swift
func application(_ application: UIApplication,
                 didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if pushComponent.handlePush(response: userInfo) {
        completionHandler(.noData)
        return
    }
    // your code...
}
```

- Using the `MessagingDelegate`, in the `didReceiveRegistrationToken` function, add the `.saveToken(_ fcmToken: _)` to save and use the token in the SDK

```swift
func messaging(_ messaging: Messaging, 
               didReceiveRegistrationToken fcmToken: String?) {
    pushComponent.saveToken(fcmToken ?? "")
}
```

## Initialisation
To initialise SDK simply call `SayTvSdk.initialise(chatName: "CHAT_NAME")`on your app start in AppDelegate or before using any SDK component.

## Register and Login
To register inside the SDK you just need to add `SayTvSadk.register(digicelId:_, email:_, avatar:_, username:_, apiToken:_, completion: _)` where the **completion** is going to have the service call response.

```swift
SayTvSdk.register(digicelId: 12,
                  email: "david2+saytv@square1.io",
                  avatar: "https://lorempixel.com/avatar.png",
                  username: "davidtwo", 
                  apiToken: "XXXXXXXXXXXXXXXXXXXX") { result in
    switch result {
    case .success(let response):
        print(response)
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```
> You must be registered before try to use the login

To login inside the SDK, you just need to add `SayTvSdk.login(digicelId:_, apiToken:_, completion: _)` where the completion is going to have the service call response

```swift
SayTvSdk.login(digicelId: digicelId, 
               apiToken: "XXXXXXXXXXXXXXXXXXXX") { result in
    switch result {
    case .success(let response):
        print(response)
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

## Chat
> You must be registered or logged in before trying to use chat.

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

## Header
> You must be registered or logged in before trying to use chat.

You are going to need to place an **UIView** anywhere you want on your screen, that will work as a container for the Chat that is going to show the chat screen, Once you have the **UIView** ready, you will have to call the `HeaderComponent(`***containerView***`: _, chatId: _, chatName: _, chatImage: _, startDate: _, endDate: _, completion: _)`. All the values are needed. The start time must be a date after or equal to now to work properly.

- In the SDK modally presented views supports status bar appearance customisation. In order to support this your project Info.plist needs to include `UIViewControllerBasedStatusBarAppearance` set to `true`. Other way SDK will use default project setup. This customisation is optional.

- Header component supports dynamic height. It can be set either by autolayout with all edges aligned to your containing view so the view resizes automatically based on the header internal elements size or the height can be set with constant value with height constraint you set. If you set header height constraint with constant value remember to change constraint priority to `height` instead of `required` in order to support header collapsing functionality. 

```swift 
class ChatViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    ....
    func startHeader() {
        let name = "Nice episode event chat"
        let image = "https://image_url_example.com"
        let startTime = dateFormatter.date(from: "24/05/2022 10:05:00")
        let endTime = dateFormatter.date(from: "26/05/2022 18:00:00")
        let theme = HeaderTheme(overlayBackgroundColor: .blue,
                                headerBackground: .yellow,
                                textColor: .brown,
                                viewerCountTextColor: .blue,
                                timeRemainingTextColor: .cyan,
                                timeIntervalTextColor: .purple)
        let _ = HeaderComponent(containerView: containerView,
                                chatId: chatId,
                                chatName: name,
                                chatImage: image,
                                startDate: startTime,
                                endDate: endTime,
                                theme: theme) { result in
            switch result {
            case .success:
                print("Header Success")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    ...
}
```

## Full Chat
> You must be registered or logged in before trying to use chat.

You're going to need to select an **UIView**, could be a placed view or **view**'s UIViewController directly that will work as the container for the Full Chat that have the Header + Chat in one component. With that decided you will have to call the `FullChatComponent(containerView: _, chatId: _, chatName: _, chatImage: _, startDate: _, endDate: _, theme: _, completion: _)`. All the values are needed. The start time must be a date after or equal to now to work properly.

```swift 
class FullChatController: UIViewController {

    ...

    func startFullChat() {
        let name = "Nice episode event chat"
        let image = "https://image_url_example.com"
        let startTime = dateFormatter.date(from: "24/05/2022 10:05:00")
        let endTime = dateFormatter.date(from: "26/05/2022 18:00:00")
        let headerTheme = HeaderTheme(overlayBackgroundColor: .blue,
                                      headerBackground: .yellow)
        let chatTheme = ChatTheme(chatText: .red,
                                  chatTextPlaceholder: .orange)
        let theme = FullChatTheme(headerTheme: headerTheme, chatTheme: chatTheme)
        let _ = FullChatComponent(containerView: view,
                                  chatId: chatId,
                                  chatName: name,
                                  chatImage: image,
                                  startDate: startTime,
                                  endDate: endTime) { result in
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

## Profile
> You must be registered or logged in before trying to use chat.

You are going to need to place an **UIView** anywhere you want on your screen, that will work as a container for the Chat that is going to show the chat screen, Once you have the **UIView** ready, you will have to call the `ProfileComponent(userId: _, `***containerView***`: _)`

```swift 
class ProfileViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    ....
    func startProfile() {
        let _ = ProfileComponent(userId: 1, containerView: containerView)
    }
    ...
}
```

## Options
- The `ChatComponent`, `HeaderComponent`, `FullChatComponent` and the `ProfileComponent` can act as an overlay just calling the next method:

```swift
component.setActAsOverlay(_ actAsOverlay: true)
```

- You can get some events that the SDK is doing using the next method with the `ChatComponent` or `FullChatComponent` instances:

```swift
component.chatActions { event in
    print("ChatActions event: \(event)")
}
```

- You can get some events that the SDK is doing using the next method with the `ProfileComponent` instance:

```swift
profileComponent.profileActions { event in
    print("ProfileActions event: \(event)")
}
```

- SayTvSdk provides possibility to fetch list of active users for a desirable list of chats:

 ```swift
SayTvSdk.getActiveUsers(chatIds: ["CHAT_ID", "CHAT_ID"]) { result in
    switch result {
    case .success(let activeUsers):
        // handle active users list
    case .failure(let error):
        // handle error response
    }
}
```
 in response closure request returns array of type `[ChatActiveUsers]` with a list of active chats active users. 
 In case chat is inactive it won't be included in API response.
 
- You can change the theme at runtime of the `ChatComponent` and the `HeaderComponent` using this after initialize the components:

```swift
let quizOptionButtonTheme = SayTvButtonTheme(enabledTitleColor: .blue,
                                             disabledTitleColor: .red,
                                             enabledBackgroundColor: .green,
                                             disabledBackgroundColor: .orange,
                                             borderColor: .clear)
let firstOptionGradient = UIColor.Gradient(startColor: .yellow, endColor: .green)
let secondOptionGradient = UIColor.Gradient(startColor: .purple, endColor: .blue)
let activeQuizTheme = ActiveQuizTheme(bottomViewBackgroundColor: .systemPink,
                                      bottomViewCornerRadius: 15.0,
                                      titleTextColor: .red,
                                      questionTextColor: .white,
                                      firstOptionVotingButtonTheme: quizOptionButtonTheme,
                                      secondOptionVotingButtonTheme: quizOptionButtonTheme,
                                      firstOptionTextColor: .yellow,
                                      secondOptionTextColor: .blue,
                                      firstOptionResultTextColor: .black,
                                      secondOptionResultTextColor: .blue,
                                      firstOptionResultBackgroundGradient: firstOptionGradient,
                                      secondOptionResultBackgroundGradient: secondOptionGradient,
                                      expirationTimeBackgroundColor: .orange,
                                      expirationTimeTextNormalColor: .gray,
                                      expirationTimeTextExpiringColor: .purple,
                                      collapseButtonTintColor: .purple)
let headerTheme = HeaderTheme(overlayBackgroundColor: .blue,
                              headerBackground: .yellow,
                              textColor: .brown,
                              viewerCountTextColor: .blue,
                              timeRemainingTextColor: .cyan,
                              timeIntervalTextColor: .purple,
                              activeQuizTheme: activeQuizTheme)
let chatOptionButtonTheme = SayTvButtonTheme(enabledTitleColor: .blue,
                                             disabledTitleColor: .purple,
                                             enabledBackgroundColor: .green,
                                             disabledBackgroundColor: .red,
                                             borderColor: .black)
let moderatorMessageTheme = ModeratorMessageTheme(titleColor: .orange,
                                                  messageColor: .black,
                                                  backgroundColor: .purple)
let quizFormTextFieldTheme = TextFieldTheme(textColor: .red,
                                            placeholderColor: .blue,
                                            backgroundColor: .gray,
                                            borderActiveColor: .black,
                                            borderInactiveColor: .gray,
                                            borderWidth: 3.0,
                                            tintColor: .purple,
                                            cornerRadius: 0.0)
let quizConfirmButtonTheme = SayTvButtonTheme(enabledTitleColor: .blue,
                                              disabledTitleColor: .red,
                                              enabledBackgroundColor: .green,
                                              disabledBackgroundColor: .orange,
                                              borderColor: .clear)
let quizFormTheme = QuizFormTheme(viewBackground: .yellow,
                                  navigationBarTitleTextColor: .cyan,
                                  titleTextColor: .blue,
                                  questionTitleTextColor: .red,
                                  questionTextFieldTheme: quizFormTextFieldTheme,
                                  optionsTitleTextColor: .purple,
                                  firstOptionTextFieldTheme: quizFormTextFieldTheme,
                                  secondptionTextFieldTheme: quizFormTextFieldTheme,
                                  closeButtonColor: .green,
                                  confirmButtonTheme: quizConfirmButtonTheme,
                                  disclaimerTextColor: .red,
                                  statusBarTheme: .darkContent)
let quizSuccessViewTheme = InfoPopupTheme(contentViewBackgroundColor: .green,
                                          contentViewBorderWidth: 3.0,
                                          contentViewBorderColor: .purple,
                                          contentViewCornerRadius: 10.0,
                                          titleTextColor: .black,
                                          subtitleTextColor: .blue,
                                          descriptionTextColor: .red,
                                          closeButtonColor: .cyan,
                                          dimmingViewBackgroundColor: .blue.withAlphaComponent(0.8))
let quizFinalResultsTheme = QuizFinalResultsTheme(viewBackgroundColor: .blue,
                                                  backgroundViewCornerRadius: 20.0,
                                                  textColor: .purple)
let quizTheme = QuizTheme(quizFormTheme: quizFormTheme,
                          quizSuccessViewTheme: quizSuccessViewTheme,
                          quizFinalResultsTheme: quizFinalResultsTheme)
let chatTheme = ChatTheme(chatText: .red,
                          chatTextPlaceholder: .orange,
                          chatTextBackground: .green,
                          hashtagText: .green,
                          chatBackground: .darkGray,
                          eventBackground: .cyan,
                          chatTextBorder: .blue,
                          commentRowBackgroundColor: .orange,
                          allOptionsButtonTheme: chatOptionButtonTheme,
                          playPauseButtonTheme: chatOptionButtonTheme,
                          pictureOptionButtonTheme: chatOptionButtonTheme,
                          newQuizButtonTheme: chatOptionButtonTheme,
                          hashtagOptionButtonTheme: chatOptionButtonTheme,
                          quizTheme: quizTheme,
                          moderatorMessageTheme: moderatorMessageTheme)
let fullChatTheme = FullChatTheme(headerTheme: headerTheme, chatTheme: chatTheme)
SayTvSdk.setChatTheme(fullChatTheme)
```

- You can change the theme at runtime of the `ProfileComponent` using this after initialize the component:

```swift
let theme = ProfileTheme(nameTextColor: .red,
                         memberSinceTextColor: .red)

SayTvSdk.setProfileTheme(_ theme: theme)
```

- You can change the quizzes theme in the `ChatTheme` declaring the `QuizTheme`, where its could use the following instances:

    - ActiveQuizTheme: Could use the following instance:
        - SayTvButtonTheme
    - InfoPopupTheme
    - QuizFinalResultsTheme
    - QuizFormTheme: Could use the following instances:
        - SayTvButtonTheme
        - StatusBarTheme
        - TextFieldTheme

```swift
var theme: QuizTheme {
    QuizTheme(
        quizFormTheme: quizFormTheme,
        quizSuccessViewTheme: quizSuccessViewTheme,
        activeQuizTheme: activeQuizTheme,
        quizFinalResultsTheme: quizFinalResultsTheme
    )
}

var quizFormTheme: QuizFormTheme {
    let questionTextFieldTheme = TextFieldTheme(
        textColor: .white,
        placeholderColor: .purple,
        backgroundColor: .systemPink,
        borderActiveColor: .blue,
        borderInactiveColor: .gray,
        borderWidth: 1.0,
        tintColor: .green,
        cornerRadius: 10.0
    )
    let optionTextFieldTheme = TextFieldTheme(
        textColor: .red,
        placeholderColor: .blue,
        backgroundColor: .gray,
        borderActiveColor: .black,
        borderInactiveColor: .gray,
        borderWidth: 3.0,
        tintColor: .purple,
        cornerRadius: 0.0
    )
    let confirmButtonTheme = SayTvButtonTheme(
        enabledTitleColor: .blue,
        disabledTitleColor: .red,
        enabledBackgroundColor: .green,
        disabledBackgroundColor: .orange
    )
    let quizFormTheme = QuizFormTheme(
        viewBackground: .yellow,
        navigationBarTitleTextColor: .cyan,
        titleTextColor: .blue,
        questionTitleTextColor: .red,
        questionTextFieldTheme: questionTextFieldTheme,
        optionsTitleTextColor: .purple,
        firstOptionTextFieldTheme: optionTextFieldTheme,
        secondptionTextFieldTheme: optionTextFieldTheme,
        closeButtonColor: .green,
        confirmButtonTheme: confirmButtonTheme,
        disclaimerTextColor: .red,
        statusBarTheme: .darkContent
    )
    return quizFormTheme
}

var quizSuccessViewTheme: InfoPopupTheme {
    InfoPopupTheme(
        contentViewBackgroundColor: .green,
        contentViewBorderWidth: 3.0,
        contentViewBorderColor: .purple,
        contentViewCornerRadius: 10.0,
        titleTextColor: .black,
        subtitleTextColor: .blue,
        descriptionTextColor: .red,
        closeButtonColor: .cyan,
        dimmingViewBackgroundColor: .blue.withAlphaComponent(0.8)
    )
}

var activeQuizTheme: ActiveQuizTheme {
    let firstOptionButtonTheme = SayTvButtonTheme(
        enabledTitleColor: .blue,
        disabledTitleColor: .red,
        enabledBackgroundColor: .green,
        disabledBackgroundColor: .orange
    )
    let secondOptionButtonTheme = SayTvButtonTheme(
        enabledTitleColor: .yellow,
        disabledTitleColor: .green,
        enabledBackgroundColor: .black,
        disabledBackgroundColor: .blue
    )
    let firstOptionGradient = UIColor.Gradient(startColor: .yellow, endColor: .green)
    let secondOptionGradient = UIColor.Gradient(startColor: .purple, endColor: .blue)

    return ActiveQuizTheme(
        bottomViewBackgroundColor: .systemPink,
        bottomViewCornerRadius: 15.0,
        titleTextColor: .red,
        questionTextColor: .white,
        firstOptionVotingButtonTheme: firstOptionButtonTheme,
        secondOptionVotingButtonTheme: secondOptionButtonTheme,
        firstOptionTextColor: .yellow,
        secondOptionTextColor: .blue,
        firstOptionResultTextColor: .black,
        secondOptionResultTextColor: .blue,
        firstOptionResultBackgroundGradient: firstOptionGradient,
        secondOptionResultBackgroundGradient: secondOptionGradient,
        expirationTimeBackgroundColor: .orange,
        expirationTimeTextNormalColor: .gray,
        expirationTimeTextExpiringColor: .purple,
        collapseButtonTintColor: .purple
    )
}

var quizFinalResultsTheme: QuizFinalResultsTheme {
    QuizFinalResultsTheme(
        viewBackgroundColor: .blue,
        backgroundViewCornerRadius: 20.0,
        textColor: .purple
    )
}
```
## Known Issues

### Chat Initialisation
When intializing chat component with unique `chatId` backend is registering chat in the database with provided start date and end date:
```
let name = "Custom Chat Name"
let start = "14/07/2022 10:00:00"
let end = "14/07/2022 12:00:00"
let dateFormatter = DateFormatter()
let startTime = dateFormatter.date(from: start)
let endTime = dateFormatter.date(from: end)
let containerView = UIView()
let _ = ChatComponent(view: containerView, startTime: startTime, endTime: endTime, chatId: "123") { result in
    // handle chat component initialisation result...
}
```

If user is initializing chat component again with the same chatId but with different dates backend does not override passed dates and original one are used instead:
```
let name = "Custom Chat Name"
let start = "20/07/2022 8:00:00"
let end = "20/07/2022 10:45:00"
let dateFormatter = DateFormatter()
let startTime = dateFormatter.date(from: start)
let endTime = dateFormatter.date(from: end)
let containerView = UIView()
let _ = ChatComponent(view: containerView, startTime: startTime, endTime: endTime, chatId: "123") { result in
    // In this scenario selected dates are not applied to the chat and the original one from the previous example will be used.
}
```

Chat can be initialised only once in database with provided dates and even when user starts chat component again but with different dates only original dates are used instead. 
If the dates changes then also `chatId` needs to be changed that is passed to chat component because we do not provide dates overriding mechanism. 
