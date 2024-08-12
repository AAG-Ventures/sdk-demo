import Foundation
import Alamofire
import metaoneSDK

class AuthClient {
    private static let baseUrl = ConfigProvider.API_BASE_URL
    private let sessionManager: Alamofire.SessionManager

    init(sessionManager: Alamofire.SessionManager) {
        self.sessionManager = sessionManager
    }

    func sampleSsoLogin(request: AuthApiModel.SampleSSOLoginRequest, completion: @escaping (APIResult<AuthApiModel.SampleSSOLoginResponse, ErrorResponse>) -> Void) {
        self.sessionManager.request("https://ws-test.aag.ventures/sso/login", method: .post, parameters: request.toAPIFormat(), encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
               do {
                   let result = try parseResponse(data: response.data, type: AuthApiModel.SampleSSOLoginResponse.self)
                   completion(.success(result))
               } catch {
                   completion(.failure(ErrorResponse.unknownError()))
               }
            case .failure(let error):
                let err = ErrorResponse.fromAPIError(response.data, responseCode: response.response?.statusCode)
                completion(.failure(err))
            }
        }
    }
}
