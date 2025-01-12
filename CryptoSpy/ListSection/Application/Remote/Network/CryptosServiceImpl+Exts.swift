//
//  Response.swift
//  CryptoSpy
//
//  Created by Dave on 08/01/25.
//

import Alamofire

extension CryptosServiceImp {
    @MainActor
    func onResponse<T>(
        response: DataResponse<T, AFError>,
        completationHandler: @MainActor @escaping (Result<T, GetServiceError>) -> Void
    ){
        switch response.result {
            case .success(let value):
                completationHandler(
                    .success(value)
                )
            case .failure(let error):
                if let afError = error.asAFError {
                    switch afError {
                        case .invalidURL(let url):
                            completationHandler(
                                .failure(.networkError(cause: http_response_error_invalid_url+"[\(url)]"))
                            )
                            break
                        case .responseSerializationFailed(let reason):
                            debugPrint("Response serialization failed: \(error.localizedDescription)")
                            debugPrint("Failure Reason: \(reason)")
                            completationHandler(
                                .failure(.networkError(cause: http_response_error_serialization_failed))
                            )
                            break
                        case .sessionInvalidated(let error):
                            debugPrint("Session Invalidated, description: \(error?.localizedDescription ?? "")")
                            completationHandler(
                                .failure(.networkError(cause: http_response_error_session_invalidated))
                            )
                        default:
                            completationHandler(
                                .failure(.networkError(cause: http_response_error_was_not_200))
                            )
                    }
                }
        }
    }
}
