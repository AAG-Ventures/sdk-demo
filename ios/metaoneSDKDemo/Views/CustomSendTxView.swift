//
//  CustomSendTxView.swift
//  metaoneSDKDemo
//
//  Created by Domantas Bart on 2023-11-06.
//

import Foundation
import SwiftUI
import metaoneSDK

struct CustomSendTxView: View {
    @Binding var isPresented: Bool
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var metaOneSDKManager: MetaOneSDKManager
    
    @FocusState private var isEditing: Bool
    
    @State private var isLoading: Bool = false
    @State var showSheet = false
    @State private var toAddress: String = ""
    @State private var amount: String = ""
    @State private var userWallets: [Wallets.UserWallet] = []
    @State private var selectedWallet: Wallets.UserWallet?
    @State private var walletAssets: [Wallets.WalletToken] = []
    @State private var selectedWalletAsset: Wallets.WalletToken? = nil
    
    private func getWallets() {
        let getWalletsCallback = M1EnqueueCallback<UserWalletsResponse>(
            onSuccess: { response in
                userWallets = response.wallets.filter { wallet in
                    return !wallet.name.contains("sec:")
                }
                selectedWallet = userWallets[0]
                walletAssets = selectedWallet?.tokens ?? []
                isLoading = false
            },
            onError: { errorResponse in
                isLoading = false
            }
        )
        metaOneSDKManager.apiManager.getWallets(callback: getWalletsCallback)
    }
    
    private func signData() {
        isLoading = true
        metaOneSDKManager.sendTransaction(wallet: selectedWallet!, address: toAddress, amount: amount, asset: selectedWalletAsset, memo: nil, personalNote: nil, callback: M1EnqueueCallback<Bool>(
            onSuccess: { response in
                isLoading = false
                M1Alert(title: "Transaction sent", message: "Your transaction has been successfuly signed and sent", actionName: "Close")
            },
            onError: { error in
                isLoading = false
                M1Alert(title: "Transaction failed", message: "Transaction failed, reason: \(error)", actionName: "Close")
            }
        ))
    }
    
    var body: some View {
        BaseViewController(uiManager: metaOneSDKManager.uiManager) {
            
            VStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.primary)
                        .padding(.bottom, 50)
                    
                } else {
                    VStack {
                        Text("Select a wallet: ").padding(.top, 18)
                        Picker("Select Wallet", selection: $selectedWallet) {
                            ForEach(userWallets, id: \.id) { wallet in
                                Text("\(wallet.name) \(String(wallet.balance.prefix(8)))")
                                    .tag(Optional(wallet))
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
                        .onChange(of: selectedWallet) { newValue in
                            walletAssets = newValue?.tokens ?? []
                            selectedWalletAsset = nil
                        }
                        if(walletAssets.count > 0){
                            Text("Select an asset: ").padding(.top, 18)
                            Picker("Select Asset", selection: $selectedWalletAsset) {
                                Text("\(selectedWallet?.currencySymbol ?? "") \(String(selectedWallet?.balance.prefix(8) ?? ""))").tag(Wallets.WalletToken?.none)
                                ForEach(walletAssets, id: \.id) { asset in
                                    Text("\(asset.currencyName ?? "") \(String(asset.balance.prefix(8)))")
                                        .tag(Optional(asset))
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                        }
                    }
                    TextField("To address:", text: $toAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isEditing)
                        .padding()
                    TextField("Amount:", text: $amount)
                        .keyboardType(.decimalPad)
                        .focused($isEditing)
                        .onReceive(amount.publisher.collect()) {
                            self.amount = String($0.prefix(while: { "0123456789,.".contains($0) }))
                        }.padding(.bottom, 18).padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    M1Button(
                        buttonText: "Sign", action: {signData()}, textColor: .white,
                        backgroundColor: .blue,
                        disabled: (selectedWallet == nil || amount == "" || toAddress == "")
                    ).padding(.bottom, 12)
                        .padding(.horizontal, 12)
                    M1Button(
                        buttonText: "Go back", action: {isPresented = false}, textColor: .white,
                        backgroundColor: .gray
                    ).padding(.horizontal, 12)
                }
            }.onAppear {
                isLoading = true
                getWallets()
            }.padding(.vertical, 24.0).padding([.leading, .trailing], 24)
                .onTapGesture {
                    isEditing = false
                }
        }
    }
}
