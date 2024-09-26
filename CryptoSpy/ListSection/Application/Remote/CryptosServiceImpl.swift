//
//  CryptosServiceImpl.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

class CryptosServiceImp: CryptosService {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchCryptos(currency: String) async -> Result<[Crypto], GetCryptoError> {
        print(currency)
        let urlRequest = URLRequest(url: URL(string: coingecko_get_all_crypto + currency)!)
        do {
            let (data, urlResponse) = try await urlSession.data(for: urlRequest)
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                return .failure(.networkError(cause: http_response_error_cast_error))
            }
            guard urlResponse.statusCode == 200 else {
                return .failure(.networkError(cause: http_response_error_was_not_200))
            }
            let Cryptos = try JSONDecoder().decode([Crypto].self, from: data)
            return .success(Cryptos)
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
}
