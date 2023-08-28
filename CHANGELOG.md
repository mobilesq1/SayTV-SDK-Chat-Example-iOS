# CHANGELOG
> **Note**\
> This is in reverse chronological order, so newer entries are added to the top.

### 13.0.0
- Add websocket implementation
- Improve several behaviours

### 12.1.6
- Resize headers ads
- Fix quiz collapse behaviour

### 12.1.5
- Change ads UI
- Show ads until reach the end time on the dashboard

### 12.1.4
- Minor UI fixs

### 12.1.3
- Set title ads when swipe
- Add extra blur to background ads

### 12.1.2
- Fix ads minor issues

### 12.1.1
- Fix ads design and behaviour

### 12.1.0
- Public `deleteLoggedUser` method on SayTvSdk that delete previous user information in the SDK, check out on [Options](#options)
- Improve the quick reaction animation
- Add advertises on the `ChatComponent`, `HeaderComponent`and `FullChatComponent`

### 12.0.5
- Apply `moderatorMessageTheme` colors correctly([Themes][])

### 12.0.4
- Add `activeQuizTheme` to [ChatTheme][]

### 12.0.3
- Move the thumb to the right
- Change clock timing format to `00:00:00`
- Collapse the quizzes options and answer when show or hide the keyboard

### 12.0.2
- Fix public typo in code, check [get active users][]
- Fixing minor issues

### 12.0.1
- Add `activeUsersThreshold` parameter to [FullChatComponent][] and [HeaderComponent][] which sets the active user threshold that the Header Component is allowed to show when we received the active user notification
- We send in background the active user event with the number of users everytime we received the notification that allow you to handle the value as you want, check [how to get active users][]
- We show between 2 to 4 quizzes options and answers on the chat and the header

### 12.0.0
- Add [analytics][] method to chats that is going to return analytics data to send parameters

### 11.3.3
- Send active user event when there is 25 or more users on the chat
- Several minor performance improvements
- Improve update user validations
- Improve badges UX
- Add multi-language to profile button

### 11.3.2
- Disable hang sentry option

### 11.3.1
- Increase sentry hang time
- Round quick reactions background
- Hide mentions when the mentions are empty
- Minor fixes

### 11.3.0
- Add quick reactions to the chat
- Fix style issues on mod messages

### 11.2.0
- Show full text on the preview link
- Add `nextChatButtonTheme` on [ChatTheme][] to customize the next chat button
- Remove update button and change avatar automatically on the profile
- Show chat is closed on the current chat

### 11.1.1
- Filter chat is close event by episode id

### 11.1.0
- Add `progressColor` and `progressBackgroundColor` to [ActiveQuizTheme][]
- Add `userJoinedBackground` to [ChatTheme][]
- Add `chatHasEndedMessage` to [ChatCustomText][]

### 11.0.0
- Add [inicializer][] that set the base url

### 10.2.1
- Improve quiz behaviour

### 10.2.0
- Add `chatCustomText` to [ChatComponenet][] and [FullChatComponent][]
- Improve the X button on the quizzes with the behaviour

### 10.1.3
- Add Sentry (Crash reporting tool) to login logs when the login fails

### 10.1.2
- Add next button when the chat received chat is close event

### 10.1.1
- Remove image on quiz and add `backgroundColor` to [ActiveQuizTheme][] 
- Add "Not authenticated" status on the chat

### 10.1.0
- Add "chat closed" button once the chat is finished that is going to send an `EVENT_NEXT_CHAT` on component's `actions`
- Add link preview and add `PreviewTheme` to [ChatTheme][] for handle preview message style
- Get url metadata using `ChatComponent` and `FullChatComponent`  on [selectedUrl()][]
- Improve observers performance when use the `ChatComponent`, `HeaderComponent` and `FullChatComponent` on [removeObservers()][]

### 10.0.0
- Minor improvenments
- Update quizzes' UI/UX and update [ActiveQuizTheme][]
- Add `shouldDisplayQuizzes` to [ChatConfiguration][] and [HeaderComponent][]
- Add [getActivUsers][] in the `ChatComponent`, `HeaderComponent` and `FullChatComponent`

### 9.0.3
- Add `profileInfoLayoutBackground` to [Profile Theme][]

### 9.0.1
- Fix profile UI
- Improvement on anti spamming behaviour

### 9.0.0
- Add `ProfileComponent` initializer without [id][]

### 8.4.0
- Add avatar selection on profile
- Change user joining behaviour
- Add chat rules screen
- Improve profile UI
- Improve some UI/UX

### 8.3.5
- Fix trimmed text on the event text

### 8.3.4
- Unsubscribe when the user is banned

### 8.3.3
- Show banned message when a banned user enter a chat again and show the full hide message.

### 8.3.2
- Improve the chat when handle a user banned

### 8.3.1
- Minor fixs

### 8.3.0
- Add `filterBackgroundColor` and `filterSelectedColor` color's parameters to [ChatTheme][], responsibles of change the background and the selector color of the filter screen.
- Stability improvements

### 8.2.2
- Multiples quizzes on the same chat, now we just show one
- Fix scroll to bottom when like a comment
- Adding multi-language to badges

### 8.2.1
- Add `usernameForbidden` value to `GeneralError`
```swift
enum GeneralError : Error {
...
    case usernameForbidden
...
}
```

### 8.2.0
- Return an array of `GeneralError` when [register][] or [update a user][]

### 8.1.0
- Add [environment][] variable to `initialise` method
    - The `environment` variables has two values `staging` and `production`

### 8.0.0
- Add [getLoggedUser][] action to SaytvSdk
- Apply color to the username as we getting from the server
- Change design on the quizzes, add different foxes when the quizzes are shown

### 7.1.1
- Improve [isHidden][] attributed on `ChatComponent`

### 7.1.0
- Fix scroll to bottom when select a top filter
- Doesn't show new message when a filter is applied
- Scroll new messages to bottom when the chat is hide with the attribute [isHidden][] is true on `ChatComponent`
- Remove text field when a filter is applied

### 7.0.1
- Fix double message in different chats
- Fix several scroll behavior

### 7.0.0
- Public and update user method and update behavior
- Show the correct state when an subscribe error occurred
- Fix profile convertion
- Remove password from update user
- Show alert when the send message get an error
- Resign first responder when the text fail
- Remove name from update user
- Change configurations values
- Change is fanzone parameter

### 6.0.4
- Add "Chat" to welcome message

### 6.0.3
- Correct typo in a message

### 6.0.2
- Center empty message on `ChatComponent` and show the message when it have to
- Hide quiz button on Chat
- Improve filter behavior on `ChatComponent`
- Fix chat actions events on Chat, show the 1st and 10th commend when occured

### 6.0.1
- Make start and end dates optionals on every component

### 6.0.0
- Take up all the view space when is landscape
- Separate configuration behavior by each `ChatComponent`
- Fix pause/play functionality when press the play button
- Create a `logout` method on the main SDK
- Fix spinner that was disappearing too soon
- Add optional `chatImage` to `FullChatComponent`
- Align the messages that you send with the other users
- Show message when the user report a message

### 5.2.2
Update SDK data synchronisation and handle unsusbscribe manually: When initialising a chat component SDK automatically subscribes user to the chat events. 
While subscription is done automatically by the SDK user now needs to handle unsubscribe manually to be in charge of chat subscription status.
This helps keeping track of chat current data if chat component is recreated multiple times (for example on device orientation change) without unsubscribing.
To read more about unsunscribing please refer to ChatComponent section.

### 5.2.0
- Update SDK initialization with app name,
- Fix landscape mode chat messages trailing margin,
- For fanzone anways enable chat despite used chat start and end dates, 
- Fix JSON serialization on iOS 11 and 12,
- Temporarily add logging mechanism in order to investigate not replicable bugs, 
- Update chat message for closed chat (start and end date set in the past),
- Update message labels literals,
- Remove duplicated chat events.
 
### 5.1.0
- Add `loading` parameter in Chat, Header and FullChat theme, to change the color of their respective components.
- 3 dots in the chat has just one color and align it with the rest of the cell

### 5.0.0
- Add `ChatConfiguration` object as a parameter to modify the behavior of the chat
    - `alignTextMessageLeft` Align the text of the message of the screen to the left
    - `displayButtonBar` Show or hide the filter, quiz, etc options on top of the chat
    - `isFanzone` Used when you wanna create a fanzone
- Remove done button from the keyboard
- Centered the likes button with the icon and message of the message
- Add loading to Chat, Header and Full chat components
- Add `EVENT_1st_COMMENT` and `EVENT_10st_COMMENT` actions when interact with the chat
- Update all events to send useful data to the client
- Add `isFanzone` parameter to create a fanzone in the Header and Full chat components.
- Add pull to refresh when there is no more data
 
### 4.0.0
- Setup celebrity comment UI
- Handle awaiting activation chat state
    - Disable chat if it’s start date is more than 10 minutes from now.
    - Activate chat 10 minutes before start date.
    - Activate header progress view on chat start date.
- Add padding to text field container on the chat
- The app can be tested on the simulator
- Hide three point on your messages
- Add a dummy header component to reuse the view without the service call
- Setup mandatory chat dates
- Use the `user_role` and `is_moderator` to identify is user is admin or not
- Add the report comment functionality
- Add multi-language supporting english and french, with english as default value

<!-- References -->
[ChatTheme]: <README.md#themes>
[ActiveQuizTheme]: <README.md#themes>
[ChatCustomText]: <README.md#chat>
[inicializer]: <README.md#initialization>
[ChatComponenet]: <README.md#chat>
[FullChatComponent]: <README.md#full-chat>
[selectedUrl()]: <README.md#options>
[removeObservers()]: <README.md#options>
[ChatConfiguration]: <README.md#chat>
[HeaderComponent]: <README.md#header>
[getActivUsers]: <README.md#options>
[Profile Theme]: <README.md#profile>
[id]: <README.md#profile>
[register]: <README.md#register>
[update a user]: <README.md#update>
[environment]: <README.md#initialization>
[getLoggedUser]: <README.md#get-logged-user>
[isHidden]: <README.md#is-hidden>
[analytics]: <README.md#analytics>
[how to get active users]: <README.md#get-active-users>
[get active users]: <README.md#get-active-users>
[Themes]: <README.md#themes>