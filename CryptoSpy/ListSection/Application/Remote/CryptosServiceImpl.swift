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
    private let enableAlamofire: Bool
    
    init(urlSession: URLSession = .shared, enableAlamofire: Bool) {
        self.urlSession = urlSession
        self.enableAlamofire = enableAlamofire
    }
    
    @MainActor
    func fetchCryptos(currency: String) async -> Result<[Crypto], GetCryptoError> {
        if(self.enableAlamofire){
            fetchCryptosAlamofire(
                currency: currency
            )
            return .success([])
        }
        return await fetchCryptosSession(currency: currency)
    }
    
    @MainActor
    func fetchCurrencies() async -> Result<[Currencies], GetCurrenciesError> {
        if(self.enableAlamofire){
            fetchCurrenciesAlamofire()
            return .success([Currencies(listSupported: [])])
        }
        return await fetchCurrenciesSession()
    }
    
    /// UrlSession
    
    func fetchCurrenciesSession() async -> Result<[Currencies], GetCurrenciesError> {
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
    
    func fetchCryptosSession(currency: String) async -> Result<[Crypto], GetCryptoError> {
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
    
    /// Alamofire
    
    final var viewModel: CryptoViewModel?
    
    @MainActor
    func completationHandlerCurrencies(result: Result<[String], GetServiceError>) -> Void {
        print("[completationHandlerCurrencies] \(result)")
        viewModel?.emitCurrenciesUpdate(currenciesResult: result)
    }
    
    @MainActor
    func completationHandlerCrypto(result: Result<[Crypto], GetServiceError>) -> Void {
        print("[completationHandlerCrypto] \(result)")
        viewModel?.emitCryptosUpdate(cryptosResult: result)
    }
    
    func fetchCryptosAlamofire(currency: String) {
        let headers: HTTPHeaders = [ .accept("application/json") ]
        _ = AF.request(coingecko_get_all_crypto + currency, headers: headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: [Crypto].self) { [unowned self] response in
                Task {
                    await onResponse(
                        response: response,
                        completationHandler: completationHandlerCrypto
                    )
                }
            }
    }
    
    func fetchCurrenciesAlamofire() {
        let headers: HTTPHeaders = [ .accept("application/json") ]
        _ = AF.request(coingecko_get_all_currencies, headers: headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: [String].self) { [unowned self] response in
                Task {
                    await onResponse(
                        response: response,
                        completationHandler: completationHandlerCurrencies
                    )
                }
            }
    }
}

