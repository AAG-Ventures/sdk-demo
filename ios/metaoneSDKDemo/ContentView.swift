//
//  ContentView.swift
//  metaoneSDKDemo
//
//  Created by Marius Šilenskis on 2023-07-11.
//

import SwiftUI
import metaoneSDK

struct ContentView: View {

    @StateObject private var sdkManager = MetaOneSDKManager()
    @State private var isAuthorized = false
    @State private var isTest = false

    func currentTimeUnix() -> TimeInterval {
        return Date().timeIntervalSince1970
    }

    var body: some View {
        BaseViewController(uiManager: sdkManager.uiManager) {
            VStack {
                if isTest {
                    TestActionsView(isLoading: false, errorMessage: "").environmentObject(sdkManager)
                } else {
                    Text(isAuthorized ? "Authorized View" : "UnAuthorized View").foregroundColor(.accentColor)
                    Spacer()
                    if isAuthorized {
                        NavigationLink(destination: AuthorizedView(isAuthorized: $isAuthorized)
                            .environmentObject(sdkManager)
                            .environmentObject(sdkManager.uiManager), isActive: $isAuthorized) {
                                EmptyView()
                            }
                            .hidden()
                    } else {
                        UnauthorizedView( isAuthorized: $isAuthorized)
                            .transition(.opacity)
                            .environmentObject(sdkManager)
                    }
                }
            }

            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                onChangeIsAuthorized()
            }
            .onAppear {
                sdkManager.initialize()
                sdkManager.setPrefix(prefix: "")
                onChangeIsAuthorized()
            }.onChange(of: sdkManager.getSessionActivityStatus()) { _ in
                isAuthorized = sdkManager.getSessionActivityStatus() != SessionActivityStatus.unauthorised

            }
        }
    }
    private func onChangeIsAuthorized() {
        let callback = M1EnqueueCallback<Bool>(
            onSuccess: { _ in
                sdkManager.setupUserData()
            },
            onError: { errorResponse in
                // Handle the error case
                print("Refresh session failed: \(errorResponse)")
            }
        )

        isAuthorized = sdkManager.getSessionActivityStatus() != SessionActivityStatus.unauthorised
        if isAuthorized {
            let expireAt: TimeInterval = TimeInterval(sdkManager.getExpireAt())
            // Check if expires at is greater than current time
            if expireAt < currentTimeUnix() + 5 {
                print("session expired")
                sdkManager.refreshSession(callback: callback)

            } else {
                sdkManager.setupUserData()
            }
        }
    }
}
