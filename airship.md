---
title: "Remote Command: Airship"
description: Tealium remote command integration for Airship on Android and Swift/iOS.
categories: [remote-commands/integrations]
menu:
  platforms:
    parent: remote-commands-integrations
    identifier: remote-commands-airship
aliases: []
toc: true
draft: false
---

## Requirements

- Airship credentials
- [Tealium for Android](/platforms/android-java/install/) or [Tealium for iOS](/platforms/ios-swift/install/) in your app
- Airship Remote Command tag in Tealium iQ Tag Management

## How It Works

The Airship integration uses the native Airship SDK, the Tealium Airship remote command module that wraps Airship methods, and the Airship Remote Command tag that translates event tracking into native Airship calls. This solution leverages the convenience of Tealium iQ Tag Management to configure a native Airship implementation without having to add vendor-specific code to your app.

Adding the Airship remote command module to your app build automatically installs and builds the required Airship libraries. There is no need to install the Airship SDK separately.

## Install

### Dependency Manager

We recommend using one of the following dependency managers for installation:

{{% note %}}If you are using the Tealium iOS (Objective-C) library, use the manual installation method. The CocoaPods and Carthage options are only available if you are using the Tealium iOS (Swift) library.{{% /note %}}

{{% code-tabs %}}

{{% code-tab "CocoaPods" %}}

To install Airship remote commands for iOS using CocoaPods:

1. Remove `tealium-swift` and `pod "Airship"` if they already exist your Podfile. The dependency for `tealium-swift` is already included in the `TealiumAirship` framework.

2. Add the following dependency to your Podfile:  
```ruby
pod "TealiumAirship"
```  
The `TealiumAirship ` pod includes the following `TealiumSwift` dependencies:  
```bash
'tealium-swift/Core'
'tealium-swift/TealiumDelegate'
'tealium-swift/TealiumRemoteCommands'
'tealium-swift/TealiumTagManagement'
```

3. Add any other required modules manually to your Podfile, such as the following:   
```bash
'tealium-swift/TealiumLogger'
'tealium-swift/TealiumLifecycle'
'tealium-swift/TealiumAppData'
```  
Learn more about the [recommended modules for iOS](https://docs.tealium.com/platforms/ios-swift/modules/).

4. Import the modules `TealiumSwift` and `TealiumAirship` in your `TealiumHelper` file, and any other files that access the `Tealium` class or the Airship remote command.

{{% /code-tab%}}

{{% code-tab "Carthage" %}}

To install Airship remote commands for iOS using Carthage:

1. Remove `tealium-swift` from your Cartfile. The dependency for `tealium-swift` is already included in the `TealiumAirship` framework.

2. Remove the following line if it exists in your Cartfile:  
```bash
github "urbanairship/ios-library""
```

3. Add the following dependency to your Cartfile:  
```bash
github "tealium/tealium-ios-airship-remote-command"
```

{{% note %}}Tealium for Swift SDK (version 1.6.5+) requires the `TealiumDelegate` module to be included with your installation.{{% /note %}}

{{% /code-tab %}}

{{% code-tab "Maven" %}}

To install Airship remote commands for Android using Maven:

1. Install Tealium's [Android SDK](/platforms/android-java/install/), if you haven't done so already.

2. Import the Tealium-Airship remote commands by adding the following dependency in your app project's `build.gradle` file:  
```groovy
dependencies {
      implementation 'com.tealium.remotecommands:airship:1.0.0'
}
```
{{% /code-tab %}}
{{% /code-tabs %}}


### Manual (iOS)

The manual installation for Airship remote commands requires one of the following iOS libraries to be installed:

- [Tealium for Swift](https://docs.tealium.com/platforms/ios-swift/)
- [Tealium for Objective-C](https://docs.tealium.com/platforms/ios-objective-c/)

To install the Airship remote commands for your iOS project:

1. Install the [Airship SDK](https://github.com/urbanairship/ios-library), if you haven't already done so.

2. Clone the [Tealium iOS Airship remote command](https://github.com/tealium/tealium-ios-airship-remote-command) repo and drag the files within the `Sources` folder into your project.

3. When initializing the Tealium SDK, update the completion handler as follows:  
```swift
tealium = Tealium(config: config) { responses in
      guard let remoteCommands = self.tealium?.remoteCommands() else {
          return
      }
      let airshipRemoteCommand = AirshipRemoteCommand().remoteCommand()
      remoteCommands.add(airshipRemoteCommand)
}
```

4. If you are using TealiumIOS, add the following code:

{{% code-tabs %}}
{{% code-tab "Swift" %}}

Add the remote command in the `TealiumHelper.swift` file as follows:

```swift
      let airshipRemoteCommand = AirshipRemoteCommand().remoteCommand()
tealium.addRemoteCommandID(
         "airship",
         description: nil,
         targetQueue: DispatchQueue.main,
         responseBlock: airshipRemoteCommand)
```

{{% /code-tab %}}

{{% code-tab "Objective-C" %}}

Import the remote command in the `TealiumHelper.m` file as follows:  
```swift
#import "TealiumRemoteCommandObjcApp-Swift.h"
```

{{% note %}}The Swift bridging header for your target is named ending with `-Swift.h`. Find this by filtering for "Module Name" in your target's build settings.{{% /note %}}

Initialize the remote command as follows:

```Objective-C
// TODO: Update for Airship
AirshipRemoteCommand *airshipRemoteCommand = [[AirshipRemoteCommand alloc] init];
TEALRemoteCommandResponseBlock *airshipCommand = [airshipRemoteCommand remoteCommand];
[[Tealium instanceForKey:@"MY_INSTANCE"] addRemoteCommandID:@"airship"
        description:@"Airship Remote Command"
        targetQueue:dispatch_get_main_queue()
        responseBlock: airshipCommand];
```
{{% /code-tab %}}

{{% /code-tabs %}}

## Initialize

To initialize the Airship remote command:

{{% code-tabs %}}
{{% code-tab "Android" %}}

The following example creates a Tealium instance and then registers the Airship remote command for Android:  
```java
Tealium.Config config = Tealium.Config.create(application, "ACCOUNT", "PROFILE", "ENVIRONMENT");
Tealium teal = Tealium.createInstance(TEALIUM_MAIN, config);

RemoteCommand airship = new AirshipRemoteCommand(TEALIUM_MAIN, config);
teal.addRemoteCommand(airship);
```

{{% /code-tab %}}
{{% code-tab "Swift" %}}

The following example creates a Tealium instance and then registers the Airship remote command for Swift:  
```swift
var teal : Tealium?
let config = TealiumConfig(
       account: "ACCOUNT",
       profile: "PROFILE",
       environment: "ENVIRONMENT",
       datasource: "DATASOURCE",
       optionalData: nil)

teal = Tealium(config: config) { responses in
  guard let remoteCommands = self.tealium?.remoteCommands() else {
        return
  }
  let airshipRemoteCommand = AirshipRemoteCommand().remoteCommand()
  remoteCommands.add(airshipRemoteCommand)
}
```
{{% /code-tab %}}

{{% code-tab "Objective-C" %}}

The following example creates a Tealium instance and then registers the Usabilla remote command for Objective-C:  

{{%note%}}The code is written in Swift and requires a Bridging Header in your Xcode project for this to work correctly.{{%/note%}}

```objc
// TODO: Update for Airship
let config = TEALConfiguration(
       account: "ACCOUNT",
       profile: "PROFILE",
       environment: "ENVIRONMENT",
       datasource: "DATASOURCE")
let teal = Tealium.newInstance(forKey: "teal", configuration: config)

      let airshipRemoteCommand = AirshipRemoteCommand().remoteCommand()
tealium.addRemoteCommandID(
         "airship",
         description: nil,
         targetQueue: DispatchQueue.main,
         responseBlock: airshipRemoteCommand)
```
{{% /code-tab %}}

{{% /code-tabs %}}

## Supported Methods

Airship methods or properties are triggered using a data mapping in the Airship Remote Command tag, by using the following Tealium commands:

| Remote Command                        | Airship Method/Property                                            |
|---------------------------------------|--------------------------------------------------------------------|
| `initialize`                          | `takeOff()`                                                        |
| `trackevent`                          | `UACustomEvent.track()`                                            |
| `trackscreenview`                     | `trackScreen`                                                      |
| `enableanalytics`                     | `analytics()?.isEnabled`                                           |
| `disableanalytics`                    | `analytics()?.isEnabled`                                           |
| `setnameduser`                        | `UAirship.namedUser()?.identifier`                                 |
| `setcustomidentifiers`                | `analytics()?.associateDeviceIdentifiers`                          |
| `enableadvertisingidentifiers`        | `analytics()?.associateDeviceIdentifiers`                          |
| `enableinappmessaging`                | `UAInAppMessageManager.shared()?.isEnabled`                        |
| `disableinappmessaging`               | `UAInAppMessageManager.shared()?.isEnabled`                        |
| `pauseinappmessaging`                 | `UAInAppMessageManager.shared()?.isPaused`                         |
| `unpauseinappmessaging`               | `UAInAppMessageManager.shared()?.isPaused`                         |
| `setinappmessagingdisplayinterval`    | `UAInAppMessageManager.shared()?.displayInterval`                  |
| `enableuserpushnotifications`         | `UAirship.push()?.userPushNotificationsEnabled`                    |
| `disableuserpushnotifications`        | `UAirship.push()?.userPushNotificationsEnabled`                    |
| `enablebackgroundpushnotifications`   | `UAirship.push()?.backgroundPushNotificationsEnabled`              |
| `disablebackgroundpushnotifications ` | `UAirship.push()?.backgroundPushNotificationsEnabled`              |
| `setpushnotificationoptions`          | `UAirship.push()?.notificationOptions`                             |
| `setforegroundpresentationoptions`    | `UAirship.push()?.defaultPresentationOptions`                      |
| `setbadgenumber`                      | `UAirship.push()?.badgeNumber`                                     |
| `resetbadgenumber`                    | `UAirship.push()?.resetBadge()`                                    |
| `enableautobadge`                     | `UAirship.push()?.isAutobadgeEnabled`                              |
| `disableautobadge`                    | `UAirship.push()?.isAutobadgeEnabled`                              |
| `enablequiettime`                     | `UAirship.push()?.isQuietTimeEnabled`                              |
| `disablequiettime`                    | `UAirship.push()?.isQuietTimeEnabled`                              |
| `setquiettimestart`                   | `UAirship.push()?.setQuietTimeStartHour`                           |
| `setchanneltags`                      | `UAirship.channel()?.tags`                                         |
| `setnamedusertags`                    | `UAirship.namedUser()?.setTags()`                                  |
| `addtag`                              | `UAirship.channel()?.addTag()`                                     |
| `removetag`                           | `UAirship.channel()?.removeTag`                                    |
| `addtaggroup`                         | `UAirship.channel()?.addTags, UAirship.namedUser()?.addTags`       |
| `removetaggroup`                      | `UAirship.channel()?.removeTags, UAirship.namedUser()?.removeTags` |
| `setattributes`                       | `UAirship.channel()?.apply`                                        |
| `displaymessagecenter`                | `UAMessageCenter.shared().display()`                               |
| `setmessagecentertitle`               | `UAMessageCenter.shared()?.defaultUI.title`                        |
| `setmessagecenterstyle`               | `UAMessageCenter.shared().defaultUI.style`                         |
| `enablelocation`                      | `UALocation.shared().isLocationUpdatesEnabled`                     |
| `disablelocation`                     | `UALocation.shared().isLocationUpdatesEnabled`                     |
| `enablebackgroundlocation`            | `UALocation.shared().isBackgroundLocationUpdatesAllowed`           |
| `disablebackgroundlocation`           | `UALocation.shared().isBackgroundLocationUpdatesAllowed`           |


{{% tip %}}Since the Airship SDK is integrated with the Tealium SDK, you may trigger any native Airship functionality by calling the SDK directly, even if the functionality is not provdied by the Tealium Airship Remote Command tag.{{% /tip %}}

### SDK Setup

#### Initialize

The Airship SDK is initialized automatically upon launch. The Airship API keys are set in the tag configuration.

| Remote Command | Airship Method |
|---|---|
| `initialize`  | `takeOff()` |

Possible UAConfig parameters

|  Parameter | Type | Example |
|----|---|---|
| `productionAppKey` (required) | String | `MyProdKey` |
| `productionAppSecret` (required) | String | `MyProdSecret` |
| `developmentAppKey` (required) | String | `MyDevKey` |
| `developmentAppSecret` (required) | String | `MyDevSecret` |
| `site` (optional) | String | `eu/us` |
| `isDataCollectionOptInEnabled` (optional) | Boolean | `true` |
| `isInProduction` (optional) | Boolean | `true` |
| `developmentLogLevel` (optional) | String | `debug/error/info/none/trace/undefined/warn` |
| `productionLogLevel` (optional) | String | `debug/error/info/none/trace/undefined/warn` |
| `isAnalyticsEnabled` (optional) | Boolean | `true` |

Airship Developer Guide: Initial SDK Setup

- [iOS](https://docs.airship.com/platform/ios/getting-started/#takeoff)
- [Android](https://docs.airship.com/platform/android/getting-started/#takeoff)

#### trackEvent

Sends a custom event to Airship.

| Remote Command | Airship Method |
|---|---|
| `trackEvent`  | `UACustomEvent.track()` |

|  Parameter | Type | Example |
|----|---|---|
| `event_name` (required) | String | `Purchase` |
| `event_properties` (optional) | JSON object | `{"my_numeric_property": 1}` |
| `event_value` (optional) | Number | `1.5` |

Airship Developer Guide: Event Tracking

- [iOS](https://docs.airship.com/platform/ios/analytics-and-reporting/#ios-custom-events)
- [Android](https://docs.airship.com/platform/android/analytics-and-reporting/#android-custom-events)

#### trackScreenView

Tracks a screen view.

| Remote Command | Airship Method |
|---|---|
| `trackScreenView`  | `UAirship.analytics()?.trackScreen` |

|  Parameter | Type | Example |
|----|---|---|
| `screen_name` (required) | String | `Home Screen` |

Airship Developer Guide: Event Tracking

- [iOS](https://docs.airship.com/platform/ios/analytics-and-reporting/#ios-screen-tracking)
- [Android](https://docs.airship.com/platform/android/analytics-and-reporting/#android-screen-tracking)

#### enableAnalytics

Enables Airship Analytics after previously being disabled (default is enabled).

| Remote Command | Airship Method |
|---|---|
| `enableAnalytics `  | `UAirship.analytics()?.isEnabled` |

Airship Developer Guide: Enable Analytics

- [iOS](https://docs.airship.com/platform/ios/analytics-and-reporting/#disabling-analytics)
- [Android](https://docs.airship.com/platform/android/analytics-and-reporting/#disabling-analytics)

#### disableAnalytics

Disables Airship Analytics after previously being enabled (default is enabled).

| Remote Command | Airship Method |
|---|---|
| `disableAnalytics `  | `UAirship.analytics()?.isEnabled` |

Airship Developer Guide: Disable Analytics

- [iOS](https://docs.airship.com/platform/ios/analytics-and-reporting/#disabling-analytics)
- [Android](https://docs.airship.com/platform/android/analytics-and-reporting/#disabling-analytics)

#### setNamedUser

Sets a known user identifier for the current app user.

| Remote Command | Airship Method |
|---|---|
| `setNamedUser`  | `UAirship.namedUser()?.identifier` |

|  Parameter | Type | Example |
|----|---|---|
| `named_user_identifier` (required) | String | `email@tealium.com` |

Airship Developer Guide: Event Tracking

- [iOS](https://docs.airship.com/platform/ios/segmentation/#named-users-ios)
- [Android](https://docs.airship.com/platform/android/segmentation/#named-users-android)

#### setCustomIdentifiers

Sets any additional custom identifiers that you deem significant for the user.

| Remote Command | Airship Method |
|---|---|
| `setCustomIdentifiers `  | `UAirship.analytics()?.associateDeviceIdentifiers` |

|  Parameter | Type | Example |
|----|---|---|
| `custom_identifiers` (required) | JSON Object (Strings Only) | `{"my_custom_identifier":"user@email.com"}` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/analytics-and-reporting/#ios-custom-identifiers)
- [Android](https://docs.airship.com/platform/android/analytics-and-reporting/#android-custom-identifiers)

#### enableAdvertisingIdentifiers

Adds advertising identifiers to the dictionary of custom identifiers (IDFV, IDFA, Ad Tracking Enabled).

| Remote Command | Airship Method |
|---|---|
| `setCustomIdentifiers `  | `UAirship.analytics()?.associateDeviceIdentifiers` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/analytics-and-reporting/#ios-custom-identifiers)
- [Android](https://docs.airship.com/platform/android/analytics-and-reporting/#android-custom-identifiers)

#### enableInAppMessaging

Enables the in-app messaging feature.

| Remote Command | Airship Method |
|---|---|
| `enableInAppMessaging `  | `UAInAppMessageManager.shared()?.isEnabled` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/in-app-automation/#component-enablement)
- [Android](https://docs.airship.com/platform/android/in-app-automation/#feature-enablement)

#### disableInAppMessaging

Disables the in-app messaging feature.

| Remote Command | Airship Method |
|---|---|
| `disableInAppMessaging `  | `UAInAppMessageManager.shared()?.isEnabled` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/in-app-automation/#component-enablement)
- [Android](https://docs.airship.com/platform/android/in-app-automation/#feature-enablement)

#### pauseInAppMessaging

Enables the in-app messaging feature.

| Remote Command | Airship Method |
|---|---|
| `pauseInAppMessaging `  | `UAInAppMessageManager.shared()?.isPaused` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/in-app-automation/#pausing-message-display)
- [Android](https://docs.airship.com/platform/android/in-app-automation/#pausing-message-display)

#### unPauseInAppMessaging

Enables the in-app messaging feature.

| Remote Command | Airship Method |
|---|---|
| `unPauseInAppMessaging `  | `UAInAppMessageManager.shared()?.isPaused` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/in-app-automation/#pausing-message-display)
- [Android](https://docs.airship.com/platform/android/in-app-automation/#pausing-message-display)

### setInAppMessagingDisplayInterval

The amount of time Airship must wait before displaying a new in-app message, in _seconds_.

| Remote Command | Airship Method |
|---|---|
| `setInAppMessagingDisplayInterval `  | `UAInAppMessageManager.shared()?.displayInterval` |

|  Parameter | Type | Example |
|----|---|---|
| `in_app_messaging_display_interval` (required) | String | `"10"` |


Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/in-app-automation/#pausing-message-display)
- [Android](https://docs.airship.com/platform/android/in-app-automation/#pausing-message-display)

#### enableUserPushNotifications

Enables user push notifications.

| Remote Command | Airship Method |
|---|---|
| `enableUserPushNotifications `  | `UAirship.push()?.userPushNotificationsEnabled` |


|  Parameter | Type | Example |
|----|---|---|
| `push_notification_options` (optional) | Array of Strings | `["badge", "sound", "announcement"]` |

Possible Push Messaging Options: "badge", "sound", "alert", "carplay", "announcement", "critical", "app_notification_settings"


Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#enabling-user-notifications)
- [Android](https://docs.airship.com/platform/android/push-notifications/#enabling-user-notifications)

#### disableUserPushNotifications

Disables user push notifications.

| Remote Command | Airship Method |
|---|---|
| `enableUserPushNotifications `  | `UAirship.push()?.userPushNotificationsEnabled` |


Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#enabling-user-notifications)
- [Android](https://docs.airship.com/platform/android/push-notifications/#enabling-user-notifications)

#### enableBackgroundPushNotifications

Enables background push notifications.

| Remote Command | Airship Method |
|---|---|
| `enableUserPushNotifications `  | `UAirship.push()?. backgroundPushNotificationsEnabled ` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#enabling-user-notifications)
- [Android](https://docs.airship.com/platform/android/push-notifications/#enabling-user-notifications)

#### disableBackgroundPushNotifications

Disables background push notifications.

| Remote Command | Airship Method |
|---|---|
| `disableBackgroundPushNotifications `  | `UAirship.push()?.backgroundPushNotificationsEnabled` |


Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#enabling-user-notifications)
- [Android](https://docs.airship.com/platform/android/push-notifications/#enabling-user-notifications)


#### setPushNotificationOptions

Sets push notification options. iOS Only.

| Remote Command | Airship Method |
|---|---|
| `setPushNotificationOptions `  | `UAirship.push()?.notificationOptions` |

|  Parameter | Type | Example |
|----|---|---|
| `push_notification_options` (required) | Array of Strings | `["badge", "sound", "announcement"]` |

Possible Push Messaging Options: "badge", "sound", "alert", "carplay", "announcement", "critical", "app_notification_settings"

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#notification-options)

#### setForegroundPresentationOptions

Sets push notification presentation options. iOS Only.

| Remote Command | Airship Method |
|---|---|
| `setForegroundPresentationOptions `  | `UAirship.push()?.defaultPresentationOptions ` |

|  Parameter | Type | Example |
|----|---|---|
| `foreground_presentation_options` (required) | Array of Strings | `["badge", "sound", "alert"]` |

Possible Foreground Presentation Options: "badge", "sound", "alert"

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#foreground-presentation-options)

#### setBadgeNumber

Sets badge number on your app's icon to a specified number. iOS Only.

| Remote Command | Airship Method |
|---|---|
| `setBadgeNumber `  | `UAirship.push()?.badgeNumber` |

|  Parameter | Type | Example |
|----|---|---|
| `badge_number` (required) | Number | `3` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#ios-feature-badges)

#### resetBadgeNumber

Resets the badge number. iOS Only.

| Remote Command | Airship Method |
|---|---|
| `setBadgeNumber `  | `UAirship.push()?.badgeNumber` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#ios-feature-badges)

#### enableAutoBadge

Enables the auto-badge feature. iOS Only.

| Remote Command | Airship Method |
|---|---|
| `enableAutoBadge `  | `UAirship.push()?.isAutobadgeEnabled` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#ios-feature-badges)

#### disableAutoBadge

Disables the auto-badge feature. iOS Only.

| Remote Command | Airship Method |
|---|---|
| `disableAutoBadge `  | `UAirship.push()?.isAutobadgeEnabled` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#ios-feature-badges)

#### enableQuietTime

Enables the quiet time feature. iOS Only.

| Remote Command | Airship Method |
|---|---|
| `enableAutoBadge `  | `UAirship.push()?.isQuietTimeEnabled` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#quiet-time)

#### disableQuietTime

Disables the quiet time feature. iOS Only.

| Remote Command | Airship Method |
|---|---|
| `disableAutoBadge `  | `UAirship.push()?.isQuietTimeEnabled` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#quiet-time)

#### setQuietTimeStart

Sets the time constraints for the Quiet Time feature. iOS only.

| Remote Command | Airship Method |
|---|---|
| `setQuietTimeStart `  | `UAirship.push()?.isQuietTimeEnabled` |

|  Parameter | Type | Example |
|----|---|---|
| `quiet_time_start_hour` (required) | Number | `3` |
| `quiet_time_start_minute` (required) | Number | `30` |
| `quiet_time_end_hour` (required) | Number | `4` |
| `quiet_time_end_hour` (required) | Number | `30` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#quiet-time)

#### setChannelTags

Calls the updateRegistration function. Must be called after changing notification options. iOS Only.

| Remote Command | Airship Method |
|---|---|
| `updateRegistration `  | `UAirship.push()?.updateRegistration` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/push-notifications/#quiet-time)

#### setNamedUserTags

Sets tags for the named user, overwriting previously-set tags.

| Remote Command | Airship Method |
|---|---|
| `setNamedUserTags `  | `UAirship.channel()?.addTags | UAirship.namedUser()?.addTags ` |

|  Parameter | Type | Example |
|----|---|---|
| `named_user_tags` (required) | String Array | `["silver-member", "gold-member"]` |
| `tag_group` (required) | String | `loyalty` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/segmentation/#ios-tag-groups)
- [Android](https://docs.airship.com/platform/android/segmentation/#android-tag-groups)

#### addTag

Adds a channel tag.

| Remote Command | Airship Method |
|---|---|
| `addTag `  | `UAirship.channel()?.addTag` |

|  Parameter | Type | Example |
|----|---|---|
| `channel_tag` (required) | String | `"a_tag"` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/segmentation/#tags)
- [Android](https://docs.airship.com/platform/android/segmentation/#tags)

#### removeTag

Removes a channel tag.

| Remote Command | Airship Method |
|---|---|
| `removeTag `  | `UAirship.channel()?.removeTag` |

|  Parameter | Type | Example |
|----|---|---|
| `channel_tag` (required) | String | `"a_tag"` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/segmentation/#tags)
- [Android](https://docs.airship.com/platform/android/segmentation/#tags)

#### addTagGroup

Adds a tag group for a named user or channel.

| Remote Command | Airship Method |
|---|---|
| `addTagGroup `  | `UAirship.channel()?.addTags | UAirship.namedUser()?.addTags ` |

|  Parameter | Type | Example |
|----|---|---|
| `named_user_tags | channel_tags` (required) | String Array | `["silver-member", "gold-member"]` |
| `tag_group` (required) | String | `loyalty` |
| `tag_type` (required) | String | `channel|named_user` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/segmentation/#ios-tag-groups)
- [Android](https://docs.airship.com/platform/android/segmentation/#android-tag-groups)

#### removeTagGroup

Removes a tag group for a named user or channel.

| Remote Command | Airship Method |
|---|---|
| `removeTagGroup`  | `UAirship.channel()?.removeTags | UAirship.namedUser()?.removeTags ` |

|  Parameter | Type | Example |
|----|---|---|
| `named_user_tags | channel_tags` (required) | String Array | `["silver-member", "gold-member"]` |
| `tag_group` (required) | String | `loyalty` |
| `tag_type` (required) | String | `channel|named_user` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/segmentation/#ios-tag-groups)
- [Android](https://docs.airship.com/platform/android/segmentation/#android-tag-groups)

#### setAttributes

Sets custom attributes.

| Remote Command | Airship Method |
|---|---|
| `setAttributes `  | `UAirship.channel()?.apply` |

|  Parameter | Type | Example |
|----|---|---|
| `attributes` (required) | JSON object | `{"last_product_purchased": "A1234567"}` |

Attribute values must be either Strings or Numbers.

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/segmentation/#attributes)
- [Android](https://docs.airship.com/platform/android/segmentation/#attributes)

#### displayMessageCenter

Displays the message center.

| Remote Command | Airship Method |
|---|---|
| `displayMessageCenter `  | `UAMessageCenter.shared().display` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/message-center/#displaying-the-message-center)
- [Android](https://docs.airship.com/platform/android/message-center/#android-rich-push-inbox-intents)

#### setMessageCenterTitle

Sets the message center title. iOS only.

| Remote Command | Airship Method |
|---|---|
| `setMessageCenterTitle `  | `UAMessageCenter.shared().defaultUI.title` |

|  Parameter | Type | Example |
|----|---|---|
| `message_center_title` (required) | String | `"Custom Message Center"` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/message-center/#title)

#### setMessageCenterStyle

Sets the message center style. iOS only.

| Remote Command | Airship Method |
|---|---|
| `setMessageCenterStyle `  | `UAMessageCenter.shared().defaultUI.style` |

|  Parameter | Type | Example |
|----|---|---|
| `message_center_style` (required) | JSON object | Example below |


     {"titleFont": {"size": Double, "name":"fontname"},
     "cellTitleFont": {"size": Double, "name":"fontname"},
     "cellDateFont": {"size": Double, "name":"fontname"},
     "navigationBarColor": {"red": Double, "green": Double, "blue": Double, "alpha": Double}
     "titleColor": {"red": Double, "green": Double, "blue": Double, "alpha": Double}
     "tintColor": {"red": Double, "green": Double, "blue": Double, "alpha": Double}
     }


Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/message-center/#styling-ios-mc)

#### enableLocation

Enables Location.

| Remote Command | Airship Method |
|---|---|
| `enableLocation `  | `UALocation.shared().isLocationUpdatesEnabled` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/location/#enabling-location)
- [Android](https://docs.airship.com/platform/android/location-targeting/#continuous-location-updates)

#### disableLocation

Disables location.

| Remote Command | Airship Method |
|---|---|
| `disableLocation `  | `UALocation.shared().isLocationUpdatesEnabled` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/location/#allow-background-location)
- [Android](https://docs.airship.com/platform/android/location-targeting/#using-airship-location)

#### enableBackgroundLocation

Enables background location.

| Remote Command | Airship Method |
|---|---|
| `enableBackgroundLocation `  | `UALocation.shared().isBackgroundLocationUpdatesAllowed` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/location/#allow-background-location)
- [Android](https://docs.airship.com/platform/android/location-targeting/#continuous-location-updates)

#### disableBackgroundLocation

Disables background location.

| Remote Command | Airship Method |
|---|---|
| `disableBackgroundLocation `  | `UALocation.shared().isBackgroundLocationUpdatesAllowed` |

Airship Developer Guide: 

- [iOS](https://docs.airship.com/platform/ios/location/#allow-background-location)
- [Android](https://docs.airship.com/platform/android/location-targeting/#continuous-location-updates)