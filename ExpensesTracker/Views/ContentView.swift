//
//  ContentView.swift
//  ExpensesTracker
//
//  Created by Kerk Wee Sin on 05/07/2022.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @EnvironmentObject var transactionListViewModel: TransactionListViewModel
    var demoData: [Double] = [0, 2, 4, 6, 12, 15, 12, 5]
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    //MARK: Title
                    Text("Overview")
                        .font(.title2)
                        .bold()
                    
                    //MARK: Chart
                    let data = transactionListViewModel.accumulateTransactions()
                    
                    if !data.isEmpty {
                        
                   
                    let totalExpenses = data.last?.1 ?? 0
                    CardView {
                        VStack(alignment: .leading) {
                            ChartLabel(totalExpenses.formatted(.currency(code: "SGD")), type: .title, format: "SGD%.02f")
                            LineChart()
                        }
                        .background(Color.systemBackground)
                    }
                    .data(data)
                    .chartStyle(ChartStyle(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.4), Color.icon)))
                    .frame(height: 300)
                    }
                    
                    //MARK: Transaction List
                    RecentTransactionList()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: Plus Icon
                ToolbarItem {
                    Image(systemName: "plus")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                        .onTapGesture {
                            let id = transactionListViewModel.transactions.count + 1
                            transactionListViewModel.writeFile(outputFile: "Data.json", transaction: Transaction(id: id, date: Date().formatted(), institution: "Testing", account: "Visa Credit Card", merchant: "UOB", amount: 15.00, type: TransactionType.credit.rawValue, categoryId: 701, category: "Drinks", isPending: false, isTransfer: true, isExpense: true, isEdited: false))
                        }
                }
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionListViewModel: TransactionListViewModel = {
        let transactionListViewModel = TransactionListViewModel()
        transactionListViewModel.transactions = transactionListPreviewData
        
        return transactionListViewModel
    }()
    
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(transactionListViewModel)
    }
}