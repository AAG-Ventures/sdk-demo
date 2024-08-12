//
//  TestActionsView.swift
//  metaoneSDKDemo
//
//  Created by alaeddine jendoubi on 11/7/2023.
//

import Foundation
import SwiftUI
import metaoneSDK

struct TestActionsView: View {
    @EnvironmentObject var  metaoneSDKManager: MetaOneSDKManager
    @State private var isAuthorized = false
    let isLoading: Bool
    let errorMessage: String

    var body: some View {
        VStack {
            Button("Test") {
                print("DO TEST ")
            }
        }
    }
}
