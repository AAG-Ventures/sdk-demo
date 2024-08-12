import Foundation
import Alamofire
import metaoneSDK

class ApiClient {
    static let shared = ApiClient()
    private static let baseUrl = ConfigProvider.API_BASE_URL

    private static let sessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.httpAdditionalHeaders?["Content-Type"] = "application/json"

        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        sessionManager.adapter = M1HeadersInterceptor()
        return sessionManager
    }()

    static var auth: AuthClient {
        let authService = AuthClient(sessionManager: sessionManager)
        return authService
    }

    private class M1HeadersInterceptor: RequestAdapter {
        func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            var modifiedRequest = urlRequest
            let uuid = UUID().uuidString

            modifiedRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            modifiedRequest.setValue("AAG", forHTTPHeaderField: "X-Domain")
            modifiedRequest.setValue(ConfigProvider.SDK_REALM, forHTTPHeaderField: "X-Realm")
            // modifiedRequest.setValue("ios://", forHTTPHeaderField: "X-Client-Uri") TODO review if needed
            modifiedRequest.setValue(ConfigProvider.SDK_VERSION, forHTTPHeaderField: "X-Client-Ver")
            modifiedRequest.setValue(uuid, forHTTPHeaderField: "X-Request-Id")

            if let url = modifiedRequest.url?.absoluteString, (url.contains("mdm/") || url.contains("sso/login")) {
                let newUrl = url.replacingOccurrences(of: "/metaone", with: "").replacingOccurrences(of: "/metaone-mainnet", with: "")
                modifiedRequest.url = URL(string: newUrl)
            }
            return modifiedRequest
        }
    }
}

func parseResponse<T: Decodable>(data: Data?, type: T.Type) throws -> T {
    guard let data = data else {
        throw NSError(domain: "Unkown error response", code: 0, userInfo: nil)
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(type, from: data)
}
