//
//  AuthorizedView.swift
//  metaoneSDKDemo
//
//  Created by alaeddine jendoubi on 11/7/2023.
//

import Foundation
import SwiftUI
import metaoneSDK

struct AuthorizedView: View {
    @EnvironmentObject var sdkManager: MetaOneSDKManager
    @State private var subscription: Subscription?
    @State private var isShowingSDKContent = false
    
    @EnvironmentObject private var uiManager: MetaOneSDKUIManager {
        didSet {
            selectedLocale = uiManager.currentLanguage
        }
    }
    
    @Binding var isAuthorized: Bool
    
    var supportedLanguages: [SupportedLanguage] = SupportedLanguage.allCases
    @State private var selectedLocale: SupportedLanguage = MetaOneSDKUIManager.shared.getCurrentLanguage()
    
    @State private var countdownString: String = "--:--"
    
    @State private var sessionFinishesAt: Int64 = 0
    @State private var timeRemaining: TimeInterval?
    @State private var timer: Timer?
    
    @State private var showApiTesting = false
    @State private var showCustomSendTx = false

    
    var body: some View {
        BaseViewController(uiManager: uiManager) {
            
            VStack {
                if isShowingSDKContent {
                    VStack {
                        sdkManager.sdkView
                    }
                } else {
                    if showCustomSendTx {
                        CustomSendTxView(isPresented: $showCustomSendTx)
                    } else {
                        VStack {
                            M1Button(
                                buttonText: "Open wallet", action: {sdkManager.openWallet()}, textColor: .white,
                                backgroundColor: .blue
                            )
                            
                            M1Button(
                                buttonText: "API Testing", action: {showApiTesting = true}, textColor: .white,
                                backgroundColor: .blue
                            )
                            
                            M1Button(
                                buttonText: "Send Transaction", action: {
                                    if sdkManager.isSignatureSet() == true {
                                        showCustomSendTx = true
                                    } else {
                                        M1Alert(title: "Signature required", message: "Please create a Signature for your account before using this feature", actionName: "OK")
                                    }
                                }, textColor: .white,
                                backgroundColor: .blue
                            )
                            
                            Picker("Select Language", selection: $selectedLocale) {
                                ForEach(supportedLanguages, id: \.self) { locale in
                                    Text(locale.name)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: selectedLocale) { newLocale in
                                uiManager.setCurrentLanguage(locale: newLocale)
                            }
                            
                            M1Button(
                                buttonText: "Change Theme (" + getTheme() + ")", action: {
                                    let newTheme = getTheme() == "light" ? "dark" : "light"
                                    setTheme(theme: newTheme)
                                    if newTheme == "dark" {
                                        uiManager.setCurrentColorScheme(colorScheme: darkTheme)
                                    } else {
                                        uiManager.setCurrentColorScheme(colorScheme: lightTheme)
                                    }
                                    
                                },
                                textColor: .white,
                                backgroundColor: .blue
                            )
                            
                            M1Button(
                                buttonText: "Refresh (" + countdownString + ")",
                                action: {
                                    sdkManager.refreshSession(callback: M1EnqueueCallback(
                                        onSuccess: { _ in
                                            self.sessionFinishesAt = sdkManager.getExpireAt()
                                            startTimer()
                                        },
                                        onError: { _ in
                                            M1Alert(title: "Session Token Failed to refresh", message: "Your account is currently active on another device. Please log out and sign in again to refresh your user token.", actionHandler: {  sdkManager.logout()
                                                isAuthorized = false
                                            }, actionName: "Logout")
                                        }
                                    ))
                                },
                                textColor: .white,
                                backgroundColor: .blue
                            )
                            
                            M1Button(
                                buttonText: "Logout", action: {
                                    sdkManager.logout()
                                    isAuthorized = false
                                }, textColor: .white,
                                backgroundColor: .red
                            )
                        }.padding(.bottom, 16.0).padding([.leading, .trailing], 24)
                    }
                }
            }.navigationBarBackButtonHidden(true)
            
        }
        .sheet(isPresented: $showApiTesting) {
            ApiTestingView()
        }
        .onAppear {
            self.sessionFinishesAt = sdkManager.getExpireAt()
            startTimer()
            subscription?.unsubscribe()
            subscription = sdkManager.events.subscribe { event in
                switch event {
                case .showSDKUI:
                    isShowingSDKContent = true
                case .hideSDKUI:
                    isShowingSDKContent = false
                case .walletCreated(let walletResult):
                    print("Wallet was created: \(walletResult)")
                @unknown default:
                    fatalError()
                }
            }
        }
        .onDisappear {
            stopTimer()
        }.onChange(of: sdkManager.getExpireAt()) {_ in
            self.sessionFinishesAt = sdkManager.getExpireAt()
            startTimer()
        }
        
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateTimeRemaining()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTimeRemaining() {
        let expirationDate = Date(timeIntervalSince1970: TimeInterval(self.sessionFinishesAt))
        let newTimeRemaining = expirationDate.timeIntervalSinceNow
        if newTimeRemaining <= 0 {
            timeRemaining = 0
            countdownString = timeString(from: 0)
        } else {
            timeRemaining = newTimeRemaining
            countdownString = timeString(from: newTimeRemaining)
        }
    }
    
    func timeString(from timeInterval: TimeInterval?) -> String {
        guard let timeInterval = timeInterval else {
            return "--:--"
        }
        
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    
}
