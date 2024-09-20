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
            let Cryptos = try await loadCryptos()
            return .success(Cryptos)
        } catch {
            return .failure(.localStorageError(cause: error.localizedDescription))
        }
    }
    
    func updateCryptos(with Cryptos: [Crypto]) async -> Result<Void, UpdateCryptoError> {
        do {
            try await save(Cryptos: Cryptos)
            return .success(())
        } catch {
            return .failure(.localStorageError(cause: error.localizedDescription))
        }
    }
    
    func getCurrencies() async -> Result<[Currencies], GetCurrenciesError> {
        return dataSource.loadItems()
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
    
    private func save(Cryptos: [Crypto]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(Cryptos)
            let outfile = try directoryURL ?? fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
