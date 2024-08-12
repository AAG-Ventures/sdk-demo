//
//  metaoneSDKDemoApp.swift
//  metaoneSDKDemo
//
//  Created by Marius Šilenskis on 2023-07-11.
//

import SwiftUI
import metaoneSDK

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

    return true
  }
}

@main
struct metaoneSDKDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
            WindowGroup {
                NavigationView {
                ContentView().navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}
