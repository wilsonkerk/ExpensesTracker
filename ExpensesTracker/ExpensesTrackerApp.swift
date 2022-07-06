//
//  ExpensesTrackerApp.swift
//  ExpensesTracker
//
//  Created by Kerk Wee Sin on 05/07/2022.
//

import SwiftUI

@main
struct ExpensesTrackerApp: App {
    @StateObject var transactionListViewModel = TransactionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListViewModel)
        }
    }
}
