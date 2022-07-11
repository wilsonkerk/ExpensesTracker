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
    @State var presented = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    let data = transactionListViewModel.accumulateTransactions()
                    
                    if !data.isEmpty {
                        
                    let totalExpenses = data.last?.1 ?? 0
                    
                    //MARK: Chart card view
                    CardView {
                        VStack(alignment: .leading) {
                            ChartLabel(totalExpenses.formatted(.currency(code: "SGD")), type: .title, format: "SGD%.02f")
                            //MARK: Charts in tab view
                            TabView {
                                LineChart()
                                BarChart()
                            }
                            .tabViewStyle(.page)
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
                            presented = true
                        }
                        .sheet(isPresented: $presented) {
                            AddTransactionView()
                        }
                        
                }
            }
            //MARK: Title
            .navigationBarTitle("Expenses Overview", displayMode: .automatic)
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
