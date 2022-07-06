//
//  TransactionListViewModel.swift
//  ExpensesTracker
//
//  Created by Kerk Wee Sin on 06/07/2022.
//

import Foundation
import Combine

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getTransaction()
    }
    
    func getTransaction() {

        Bundle.main.readFile(file: "DummyData.json")
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching transactions", error.localizedDescription)
                    
                case .finished:
                    print("Finished fetching transactions")
                }
            } receiveValue: {[weak self] result in
                self?.transactions = result
                dump(self?.transactions)
            }
            .store(in: &cancellables)

    }
}

extension Bundle{
  // MARK: Read file 
    func readFile(file: String) -> AnyPublisher<Data, Error> {
        self.url(forResource: file, withExtension: nil)
            .publisher
            .tryMap{ string in
                guard let data = try? Data(contentsOf: string) else {
                    fatalError("Failed to load \(file) from bundle.")
                }
                return data
            }
            .mapError { error in
                return error
            }.eraseToAnyPublisher()
    }
}
