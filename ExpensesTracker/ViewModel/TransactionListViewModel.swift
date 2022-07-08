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
    
    var dataFileName = "Data.json"

    init() {
        getTransaction()
    }
    
    func getTransaction() {
        let filePath = getDocumentsDirectory().appendingPathComponent(dataFileName)
        let bundleFilePath = Bundle.main.url(forResource: dataFileName, withExtension: nil)!
        
        if !FileManager.default.fileExists(atPath: filePath){
            FileManager.default.secureCopyItem(at: bundleFilePath, to: URL.init(fileURLWithPath: filePath))
        }
        
        self.transactions = self.readFile(inputFile: dataFileName)
        
    }
    
    func getDocumentsDirectory() -> NSString {
         let paths =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    func groupTransactionByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else {return [:]}
        
        let groupedTransactions = TransactionGroup(grouping: transactions) { $0.month }
        
        return groupedTransactions
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        print("accumulateTransactions")
        guard !transactions.isEmpty else {return []}
        
        let today = "02/17/2022".dateParsed()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print("dateInterval", dateInterval)
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24) {
            let dailyExpenses = transactions.filter {$0.dateParsed == date && $0.isExpense}
            let dailyTotal = dailyExpenses.reduce(0) {$0 - $1.signedAmount}
            
            sum += dailyTotal
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(), "dailyTotal:", dailyTotal, "sum", sum)
        }
        
        return cumulativeSum
    }
    
    func readFile(inputFile: String) -> [Transaction] {
        var transactions = [Transaction]()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let inputFile = fileURL.appendingPathComponent(inputFile)
        
        do {
            let savedData = try Data(contentsOf: inputFile)
            let jsonDecoder = JSONDecoder()
            transactions = try jsonDecoder.decode([Transaction].self, from: savedData)
            
        } catch {
            print("Error readFile:", error.localizedDescription)
        }
        return transactions
    }
    
    func writeFile(outputFile: String, transaction: Transaction) {

        var transactions = [Transaction]()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let filePath = fileURL.appendingPathComponent(outputFile)
        
        transactions = readFile(inputFile: outputFile)
        transactions.append(transaction)
          
        
        do {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(transactions) {
                if let data = String(data: encoded, encoding: .utf8) {
                    try data.write(to: filePath,
                               atomically: true,
                               encoding: .utf8)
                    self.transactions = transactions
                    print("Saved data:", data)
                }
            }
           
            
        } catch {
            print("error:", error.localizedDescription)
        }
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

extension FileManager {

    func secureCopyItem(at srcURL: URL, to dstURL: URL) {
        do {
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
        }
    }

}