//
//  UnauthorizedView.swift
//  metaoneSDKDemo
//
//  Created by alaeddine jendoubi on 11/7/2023.
//

import Foundation
import SwiftUI
import metaoneSDK

struct UnauthorizedView: View {
    @EnvironmentObject var metaoneSDKManager: MetaOneSDKManager

    @State private var showSignInForm = false
    @Binding var isAuthorized: Bool

    func handleLoginCompletition () {
        isAuthorized = true
    }

    var body: some View {

        VStack {

            M1Button(
                buttonText: "Authorize", action: { showSignInForm = true }, textColor: .white, width: 300,
                backgroundColor: .blue
            ).sheet(isPresented: $showSignInForm) {
                LoginView(completion: handleLoginCompletition).environmentObject(metaoneSDKManager)

            }

        }.padding([.leading, .trailing], 12).padding(.bottom, 16)

    }
}
