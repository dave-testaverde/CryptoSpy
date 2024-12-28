//
//  CryptosServiceImpl.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation
import Alamofire

class CryptosServiceImp: CryptosService {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchCryptos(currency: String) async -> Result<[Crypto], GetCryptoError> {
        let urlRequest = URLRequest(url: URL(string: coingecko_get_all_crypto + currency)!)
        do {
            let (data, urlResponse) = try await urlSession.data(for: urlRequest)
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                return .failure(.networkError(cause: http_response_error_cast_error))
            }
            guard urlResponse.statusCode == 200 else {
                return .failure(.networkError(cause: http_response_error_was_not_200))
            }
            let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
            return .success(cryptos)
        } catch {
            return .failure(.networkError(cause: error.localizedDescription))
        }
    }
    
    func fetchCurrencies() async -> Result<[Currencies], GetCurrenciesError> {
        let urlRequest = URLRequest(url: URL(string: coingecko_get_all_currencies)!)
        do {
            let (data, urlResponse) = try await urlSession.data(for: urlRequest)
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                return .failure(.networkError(cause: http_response_error_cast_error))
            }
            guard urlResponse.statusCode == 200 else {
                return .failure(.networkError(cause: http_response_error_was_not_200))
            }
            let currencies = try JSONDecoder().decode([String].self, from: data)
            print(Currencies(listSupported: currencies))
            return .success([Currencies(listSupported: currencies)])
        } catch {
            print("error " + error.localizedDescription)
            return .failure(.networkError(cause: error.localizedDescription))
        }
    }
    
    /// Alamofire
    
    final var viewModel: CryptoViewModel?
    
    @MainActor
    func completationHandler(result: Result<[Crypto], GetCryptoError>) {
        print("[completationHandler] \(result)")
        viewModel?.emitCryptosUpdate(cryptosResult: result)
    }
    
    func fetchCryptosA(currency: String, completationHandler: @escaping (Result<[Crypto], GetCryptoError>) -> Void) {
        let headers: HTTPHeaders = [ .accept("application/json") ]
        _ = AF.request(coingecko_get_all_crypto + currency, headers: headers)
            .responseDecodable(of: [Crypto].self) { cryptos in
                guard cryptos.response?.statusCode == 200 else {
                    return completationHandler(
                        .failure(.networkError(cause: http_response_error_was_not_200))
                    )
                }
                completationHandler(
                    .success(cryptos.value!)
                )
            }
    }
}

