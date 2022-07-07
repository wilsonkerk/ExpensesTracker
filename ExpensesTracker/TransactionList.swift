//
//  TransactionList.swift
//  ExpensesTracker
//
//  Created by Kerk Wee Sin on 06/07/2022.
//

import SwiftUI

struct TransactionList: View {
    @EnvironmentObject var transactionListViewModel: TransactionListViewModel
    
    var body: some View {
        VStack {
            List {
                //MARK: Transactions Group
                ForEach(Array(transactionListViewModel.groupTransactionByMonth()), id: \.key) { month, transaction in
                    //MARK: Transactions List
                    Section {
                        ForEach(transaction) {transaction in
                            TransactionRow(transaction: transaction)
                        }
                    } header: {
                        //MARK: Transaction Month
                       Text(month)
                    }
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TransactionList_Previews: PreviewProvider {
    static let transactionListViewModel: TransactionListViewModel = {
        let transactionListViewModel = TransactionListViewModel()
        transactionListViewModel.transactions = transactionListPreviewData
        
        return transactionListViewModel
    }()
    
    static var previews: some View {
        Group {
            NavigationView {
                TransactionList()
            }
            NavigationView {
                TransactionList()
                    .preferredColorScheme(.dark)
            }
        }
        .environmentObject(transactionListViewModel)
    }
}
