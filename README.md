# Easy Audio
+ Support record audio file.
+ Friendly support convert speed to text.

# How to use
```
context.startRecord()
```


Please make sure have handle permission. (Can use: `https://pub.dev/packages/permission_handler`)

# How to Setup
## Android

### Update `android/app/build.gradle`
```
compileSdkVersion 33

```

```

minSdkVersion 21

```

### Update `android/app/src/main/AndroidManifest.xml`

```
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

## iOS

### Update `ios/Runner/Info.plist`

```
	<key>NSMicrophoneUsageDescription</key>
	<string>Allow $(APP_NAME) access microphone?</string>
```