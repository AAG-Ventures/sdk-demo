//
//  ApiTestingView.swift
//  metaoneSDKDemo
//
//  Created by Domantas Bart on 2023-08-24.
//

import Foundation
import SwiftUI
import metaoneSDK

struct ApiTestingView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var metaOneSDKManager: MetaOneSDKManager

    private var options = [
        "GET:Wallets",
        "GET:Currencies",
        "GET:NFTs",
        "GET:Transactions",
        "GET:Contacts"
    ]

    private var isLoading: Bool = false

    @State private var selectedApiMethod: String = "GET:Wallets"
    @State private var apiResponse: String = ""

    private func getWallets() {
        let getWalletsCallback = M1EnqueueCallback<UserWalletsResponse>(
            onSuccess: { response in
                if let responseData = try? JSONEncoder().encode(response),
                           let responseConverted = String(data: responseData, encoding: .utf8) {
                            apiResponse = responseConverted
                        }
            },
            onError: { errorResponse in
                apiResponse = "Error getting wallets: \(errorResponse.error)"
            }
        )
        metaOneSDKManager.apiManager.getWallets(callback: getWalletsCallback)
    }

    private func getCurrencies() {
        let getCurrenciesCallback = M1EnqueueCallback<UserCurrenciesResponse>(
            onSuccess: { response in
                if let responseData = try? JSONEncoder().encode(response),
                           let responseConverted = String(data: responseData, encoding: .utf8) {
                            apiResponse = responseConverted
                        }
            },
            onError: { errorResponse in
                apiResponse = "Error getting currencies: \(errorResponse.error)"
            }
        )
        metaOneSDKManager.apiManager.getCurrencies(callback: getCurrenciesCallback)
    }

    private func getNfts() {
        let getNftsCallback = M1EnqueueCallback<UserNFTsResponse>(
            onSuccess: { response in
                if let responseData = try? JSONEncoder().encode(response),
                           let responseConverted = String(data: responseData, encoding: .utf8) {
                            apiResponse = responseConverted
                        }
            },
            onError: { errorResponse in
                apiResponse = "Error getting NFTs: \(errorResponse.error)"
            }
        )
        metaOneSDKManager.apiManager.getNfts(walletId: nil, queryString: nil, limit: 20, offset: 0, callback: getNftsCallback)
    }

    private func getTransactions() {
        let getTransactionsCallback = M1EnqueueCallback<TransactionAPIModel.TransactionsResponse>(
            onSuccess: { response in
                if let responseData = try? JSONEncoder().encode(response),
                           let responseConverted = String(data: responseData, encoding: .utf8) {
                            apiResponse = responseConverted
                        }
            },
            onError: { errorResponse in
                apiResponse = "Error getting transactions: \(errorResponse.error)"
            }
        )
        metaOneSDKManager.apiManager.getTransactions(walletId: nil, assetRef: nil, bip44: nil, tokenAddress: nil, page: 20, offset: 0, callback: getTransactionsCallback)
    }
    
    private func getUserContacts() {
        let getUserContactsCallback = M1EnqueueCallback<ContactApiModel.ContactsResponse>(
            onSuccess: { response in
                if let responseData = try? JSONEncoder().encode(response),
                           let responseConverted = String(data: responseData, encoding: .utf8) {
                            apiResponse = responseConverted
                        }
            },
            onError: { errorResponse in
                apiResponse = "Error getting transactions: \(errorResponse.error)"
            }
        )
        metaOneSDKManager.apiManager.getUserContacts(callback: getUserContactsCallback)
    }

    private func handleSelectedApiMethod(_ selectedMethod: String) {
            switch selectedMethod {
            case "GET:Wallets":
                getWallets()
            case "GET:Currencies":
                getCurrencies()
            case "GET:NFTs":
                getNfts()
            case "GET:Transactions":
                getTransactions()
            case "GET:Contacts":
                getUserContacts()
            default:
                break
            }
        }

    var body: some View {
        BaseViewController(uiManager: metaOneSDKManager.uiManager) {

            VStack {
                Picker("Select API method", selection: $selectedApiMethod) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedApiMethod) { newMethod in
                    handleSelectedApiMethod(newMethod)
                }
                .onAppear {
                    handleSelectedApiMethod(selectedApiMethod)
                 }
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.primary)
                        .padding(.bottom, 50)

                } else {
                    TextEditor(text: $apiResponse)
                        .foregroundColor(.black)
                        .background(.white)
                }
            }
        }
    }
}
