This guide will walk you through integrating the MetaOne® wallet into your iOS app.

**Step 1: Setting up SSH for access to your repositories**

After you will be accepted to the SDK integration program, you will be provided with SSH keys required to access secure repositories. If you haven’t received them please ask your integration success manager to provide you files.

**Step 2: Adding MetaOne Wallet SDK to your project**

To begin integrating the MetaOne Wallet SDK into your iOS application, you need to add the SDK dependencies to your project. The SDK package is hosted on Cocoapods, making it easy to include in your app using your project’s podfile:

Create a .plist file named metaoneSDKConfig and add following config:\*\*

`<?xml version="1.0" encoding="UTF-8"?>`

`<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">`

`<plist version="1.0">
<dict>
<key>SDK_ENVIRONMENT</key>
<string>test (test(testnet), stage(mainnet), prod(mainnet))</string>
<key>SDK_API_CLIENT_REFERENCE</key>
<string>given by aag</string>
<key>SDK_CONFIG_URL</key>
<string>your personal SDK configuration json url</string>
<key>SDK_REALM</key>
<string>given by aag</string>
<key>SDK_PUB_PHRASE</key>
<string>given by aag</string>
</dict>
</plist>`

**Step 3: Add the following code to your Podfile:**

`use_frameworks!
  pod "metaoneSDK", "~> 1.9.1"
  pod "CYBAVOWallet", :git => 'https://github.com/AAG-Ventures/wallet-fork.git'`

**Step 4: Setup event handler**

 ` subscription = sdkManager.events.subscribe { event in
   switch event {
   case .showSDKUI:
	//Render metaoneSDKManager().sdkView
        isShowingSDKContent = true
   case .hideSDKUI:
        isShowingSDKContent = false
   @unknown default:
        fatalError()
   }
}`

**Step 5: Creating User Session**

`Import metaoneSDK.
Initialize sdkManager - var sdkManager = MetaOneSDKManager()
Initialize sdk - sdkManager.initialize().`

To successfully initialize a user session your back-end integration has to be ready first.  
Your backend should receive an Authorization token during the initialization request.  
Initialize the session by calling: `metaOneSDKManager.login(token, this, callback)`

Your session is initialized. You can now use all other functions that require Authorization.

Call `metaOneSDKManager.setup()` to initialize user profile data
