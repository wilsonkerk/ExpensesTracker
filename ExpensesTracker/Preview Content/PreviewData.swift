//
//  PreviewData.swift
//  ExpensesTracker
//
//  Created by Kerk Wee Sin on 05/07/2022.
//

import Foundation
import SwiftUI

var transactionPreviewData = Transaction(id: 1, date: "03/07/2022", institution: "Desjardins", account: "Visa Desjardins", merchant: "Apple", amount: 15.49, type: "debit", categoryId: 801, category: "Software", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)
