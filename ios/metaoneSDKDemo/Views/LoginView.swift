//
//  LoginView.swift
//  metaoneSDKDemo
//
//  Created by alaeddine jendoubi on 11/7/2023.
//

import Foundation
import SwiftUI
import metaoneSDK

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var metaOneSDKManager: MetaOneSDKManager

    let completion: () -> Void
    @State var subscription: metaoneSDK.Subscription?
    @State private var sdkView: AnyView?

    public init( completion: @escaping () -> Void ) {

        self.completion = completion

    }

    @State private var email = ""
    @State private var errorMessage = ""
    @State private var isLoading = false

    var isFormValid: Bool {
        return !email.isEmpty
    }
    func resolveAuthrisation () {
        completion()
        presentationMode.wrappedValue.dismiss()
    }

    func clearError () {
        if !errorMessage.isEmpty {
            errorMessage = ""
        }
    }

    func handleLogin () {
        isLoading = true
        let loginRequest = AuthApiModel.SampleSSOLoginRequest(email: email)
        let callback = M1EnqueueCallback<AuthApiModel.SampleSSOLoginResponse>(
            onSuccess: { response in
                handleAuthorization(accesToken: response.token)
            },
            onError: { errorResponse in
                isLoading = false
                errorMessage="Error Code :\(String(describing: errorResponse.code)) Message : \(errorResponse.error)"
            }
        )
        ApiClient.auth.sampleSsoLogin(request: loginRequest) { result in
            switch result {
                case .success(let response):
                    callback.invokeSuccess(response: response)
                case .failure(let error):
                    callback.invokeError(errorBody: error)
            }
        }
    }

    func handleAuthorization(accesToken: String) {
        let loginRequest = AuthApiModel.SSOLoginRequest(token: accesToken)
        let callback = M1EnqueueCallback<Bool>(
            onSuccess: { _ in
                metaOneSDKManager.setup(completion: {resolveAuthrisation()})
            },
            onError: { resp in
                if !APIError.isLinkRequired(code: resp.code, responseCode: resp.responseCode) {
                    isLoading = false
                    errorMessage="Error Code :\(String(describing: resp.code)) Message : \(resp.error)"
                }
            }
        )
        self.metaOneSDKManager.login(requestData: loginRequest, callback: callback)
    }

    var body: some View {
        BaseViewController(uiManager: metaOneSDKManager.uiManager) {

            VStack {
                if let sdkView = sdkView {
                    sdkView

                } else {
                    Text("Login")
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .padding()

                    TextField("Email", text: $email, prompt: Text("Email").foregroundColor(.gray))
                        .onChange(of: email) {_ in
                            clearError()
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 40)
                        .cornerRadius(10)
                        .frame(width: 350)
                        .foregroundColor(metaOneSDKManager.uiManager.colorScheme.black.toSwiftUIColor())
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.5)
                        ).padding(.vertical, 10)
                        .disabled(isLoading )

                    Text(errorMessage).font(.footnote).foregroundColor(.red)

                    M1Button(
                        buttonText: "Login", action: handleLogin, textColor: .white, width: 320,
                        backgroundColor: .blue,
                        isLoading: isLoading,
                        disabled: !isFormValid
                    )
                }

            }.padding(.horizontal, 20)

        }
        .onReceive(metaOneSDKManager.$events) { events in
            if let subscription = subscription {
                subscription.unsubscribe()
            }

            subscription = events.subscribe {event in
                let isAuthorized = metaOneSDKManager.getSessionActivityStatus() != SessionActivityStatus.unauthorised

                if isAuthorized {
                    resolveAuthrisation()
                }

                if  event == .hideSDKUI {
                    self.sdkView = nil
                } else if event == .showSDKUI {
                    self.sdkView = metaOneSDKManager.sdkView
                }
            }
        }
    }
}
