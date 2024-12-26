//
//  CurrenciesDataSource.swift
//  CryptoSpy
//
//  Created by Dave on 17/09/24.
//

import SwiftData

final class CurrenciesDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = CurrenciesDataSource()

    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: Currencies.self)
        self.modelContext = modelContainer.mainContext
    }

    func appendItem(item: Currencies) {
        modelContext.insert(item)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchItems() -> [Currencies] {
        do {
            return try modelContext.fetch(FetchDescriptor<Currencies>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func removeItem(_ item: Currencies) {
        modelContext.delete(item)
    }
    
    func removeAll(){
        do {
            try modelContext.delete(model: Currencies.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor
    func loadItems(onError: Bool = false) -> Result<[Currencies], GetCurrenciesError>  {
        do {
            if(onError){
                throw GetCurrenciesError.localStorageError(cause: "")
            }
            let currencies = try modelContext.fetch(FetchDescriptor<Currencies>())
            return .success(currencies)
        } catch {
            print("error")
            return .failure(.localStorageError(cause: error.localizedDescription))
        }
    }
    
}

