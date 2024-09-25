//
//  CryptosDbImp.swift
//  CryptoSpy
//
//  Created by Dave on 31/07/24.
//

import Foundation

class CryptosDbImp: CryptosDb {
    var directoryURL: URL?
    
    private let dataSource: CurrenciesDataSource
    
    init(directoryURL: URL? = nil, dataSource: CurrenciesDataSource = CurrenciesDataSource.shared) {
        self.directoryURL = directoryURL
        self.dataSource = dataSource
    }
    
    func getCryptos() async -> Result<[Crypto], GetCryptoError> {
        do {
            let cryptos = try await loadCryptos()
            return .success(cryptos)
        } catch {
            return .failure(.localStorageError(cause: error.localizedDescription))
        }
    }
    
    func updateCryptos(with cryptos: [Crypto]) async -> Result<Void, UpdateCryptoError> {
        do {
            try await saveCryptos(cryptos: cryptos)
            return .success(())
        } catch {
            return .failure(.localStorageError(cause: error.localizedDescription))
        }
    }
    
    func getCurrencies() async -> Result<Currencies, GetCurrenciesError> {
        return dataSource.loadItems()
    }
    
    func updateCurrencies(with currencies: Currencies) async -> Result<Void, UpdateCurrenciesError> {
        do {
            try await saveCurrencies(currencies: currencies)
            return .success(())
        } catch {
            return .failure(.localStorageError(cause: error.localizedDescription))
        }
    }
    
    // MARK: - FileManager
    
    private func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Cryptos.data")
    }
    
    private func loadCryptos() async throws -> [Crypto] {
        let task = Task<[Crypto], Error> {
            let fileURL = try directoryURL ?? fileURL()
            guard let data = try? Data(contentsOf: fileURL) else { return [] }
            let Cryptos = try JSONDecoder().decode([Crypto].self, from: data)
            return Cryptos
        }
        return try await task.value
    }
    
    private func saveCryptos(cryptos: [Crypto]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(cryptos)
            let outfile = try directoryURL ?? fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    private func saveCurrencies(currencies: Currencies) async throws {
        dataSource.appendItem(item: currencies)
    }
}
