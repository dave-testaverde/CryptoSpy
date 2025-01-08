//
//  Response.swift
//  CryptoSpy
//
//  Created by Dave on 08/01/25.
//

import Alamofire

extension CryptosServiceImp {
    @MainActor
    func onResponse(
        response: DataResponse<[Crypto], AFError>,
        completationHandler: @MainActor @escaping (Result<[Crypto], GetCryptoError>) -> Void
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
                        default:
                            completationHandler(
                                .failure(.networkError(cause: http_response_error_was_not_200))
                            )
                    }
                }
        }
    }
}
