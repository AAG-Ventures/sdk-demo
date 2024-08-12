# MetaOne Wallet Integration Guide for React Native

## Overview

This guide will walk you through integrating the MetaOne wallet into your React Native app. Provide your users with a secure and convenient way to manage their digital assets with MetaOne Wallet. It is a custody wallet that eliminates the need for private keys, passphrases, or hardware wallets.

## Setup

**Step 1: Setting up SSH for access to your repositories**

After you are accepted to the SDK integration program, you will be provided with SSH keys required to access secure repositories. If you haven’t received them please ask your integration success manager to provide you files.

**Step 2: Installing dependency**

`npm i @aag-development/react-native-metaone-wallet-sdk` or `yarn add @aag-development/react-native-metaone-wallet-sdk`

**Step 3: Adding MetaOne Wallet SDK to your project**

### iOS
#### 1. Add the following code to your Podfile:
```
// Add to top of Podfile
source 'https://cdn.cocoapods.org/'
source 'https://bitbucket.org/cybavo/Specs_512.git'
```

```
target 'YourTarget' do
  use_frameworks! // Add this line
end
```

```
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0' // Add this line
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES' // Add this line
        end
    end
end
```

#### 2. Run `pod install` in `ios/`

**Step 4: Initializing SDK**

Initialize MetaOne SDK:

```
await initialize({
    sdkEnvironment: sdkConfig.environment, // test, stage, prod
    sdkKey: Platform.OS === "ios" ? sdkConfig.iOSKey : sdkConfig.androidKey,  // given by aag
    sdkConfigUrl: sdkConfig.configUrl, // given by aag
    sdkApiClientReference: sdkConfig.apiClientReference, //  given by aag
    sdkApiKeyPhrase: sdkConfig.apiKeyPhrase, // given by client
    version, // app version
    sdkRealm: sdkConfig.realm, //  given by aag
});
```

Check session status:

```await getSessionActivityStatus();```

**Step 4: Creating User Session**

To successfully initialize a user session your back-end integration has to be ready first. Your backend should receive an Authorization token during the initialization request.

Initialize the session by calling: `logInWithSSO(token);`

Your session is initialized. You can now use all other functions that require Authorization

Call `setupUserData();` to initialize user profile data


## Using SDK functions

### SDK session management functions

- `initialize(Map<String,String> sdkConfig)`: Initializes the MetaOne SDK by setting up the app configuration. Provide SDKConfig map with configuration values.
- `setupUserData()`: Sets up the user data by fetching the user profile and user state. This function ensures that the user profile and user state are available for use.
- `loginWithSSO(String token)`: Performs the login process by sending an authorization token.
- `refreshSession()`: Refreshes the user session to extend the session expiration time.
- `openWallet()`: For new users opens the Signature creation flow. If Signature is created - opens Wallet activity.
- `getSessionActivityStatus()`: Retrieves the current session activity status, which can be one of the values defined in the `SessionActivityStatus` enum.
- `logout()`: Logs out the user by clearing the session data, signing out the wallet service.
- (In progress) `cancelTokenExpirationCountdown()`: Cancels the token expiration countdown if it is currently running.
- (In progress) `setOnTokenExpirationListener(onTokenExpirationListener: OnTokenExpirationListener)`: Sets the listener for token expiration events. You can implement the `OnTokenExpirationListener` interface to handle token expiration, session activity changes, and token countdown events.
- `getExpireAt()`: Long: Retrieves the expiration timestamp of the user session.

### SDK API management functions (In progress)

- `getWallets()`: Retrieves the user's wallets.
- `getCurrencies()`: Retrieves the user's currencies.
- `getNFTs(walletId: String?, searchString: String?, limit: Int = 100, offset: Int = 0)`: Retrieves the user's NFTs (Non-Fungible Tokens) based on the wallet ID and optional search parameters. You can provide the wallet ID, a search string, and optional limit and offset values.
- `getTransactions(walletId: String?, assetRef: String?, bip44: String?, tokenAddress: String?, page: Int?, offset: Int?)`: Retrieves the transactions for a specific wallet and optional parameters. You need to provide the wallet ID and can optionally provide the asset reference, bip44 value, token address, page number, and offset.
- (In progress)`getTransaction(walletId: String?, chainId: String?, bip44: String?)`: Retrieves a specific transaction based on the wallet ID, chain ID, and bip44 value. You need to provide the wallet ID, chain ID, and bip44 value.
- `getUserContacts()`: Retrieves the user's contacts from the address book.
- `getUserContactWithId(id: String)`: Retrieves a specific contact based on the contact ID. You need to provide the contact ID.

### SDK UI management functions

- `getColorsScheme()`: Retrieves the currently set colors for the MetaOne SDK UI.
- `setColorsScheme(colors:ColorsScheme)`: Sets the colors for the MetaOne SDK UI.
- `getCurrentLanguage()`: Retrieves the currently set language for the MetaOne SDK UI. It returns a Locale object representing the language.
- `setCurrentLanguage(locale: String)`: Sets the language for the MetaOne SDK UI. You need to provide the desired language as a String value, representing the locale.

---

Please note that some functions are marked as "In progress," indicating they may not be fully implemented yet. Make sure to check the official documentation for the latest updates and usage instructions.

### Important:

To ensure a good user experience, we recommend you implement:

1. Initialize user session during initial auth
2. Refresh the user session when the session expires.