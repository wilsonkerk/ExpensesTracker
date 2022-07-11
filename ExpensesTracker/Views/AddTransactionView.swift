//
//  AddTransactionView.swift
//  ExpensesTracker
//
//  Created by Kerk Wee Sin on 09/07/2022.
//

import SwiftUI
import SwiftUIFontIcon

struct AddTransactionView: View {
    @EnvironmentObject var transactionListModelView: TransactionListViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var selectedItems: [Category] = []
    @State var isCredit: Bool = false
    @State var date = Date()
    @State var amount: String = ""
    @State var merchant: String = ""
    @State var account: String = ""
    
    var body: some View {
        // Used to define the number of item a row.
        let columns = [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
        
        List {
            //MARK: Transaction Type
            Text("Transaction Type")
            LazyVGrid(columns: columns) {
                ForEach(Category.all, id: \.self) { item in
                    GridColumn(item: item, items: $selectedItems)
                        .onTapGesture {
                            selectedItems.removeAll()
                            selectedItems.append(item)
                        }
                }
            }
            //MARK: Credit or Debit
            VStack(alignment: .leading){
                HStack {
                    Text(isCredit ? "Credit" : "Debit")
                    Spacer()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Toggle("Debit", isOn: $isCredit).labelsHidden()
                    
                }
                
                Divider()
                
                //MARK: Transaction Type
                TextField("Enter amount", text: $amount)
                    .padding([.top, .bottom])
                    .keyboardType(.decimalPad)
                
                Divider()
                //MARK: Merchant
                TextField("Enter merchant", text: $merchant)
                    .padding([.top, .bottom])
                
                Divider()
                //MARK: Account
                TextField("Enter account", text: $account)
                    .padding([.top, .bottom])
                
                Divider()
                //MARK: Transaction Date
                VStack(alignment: .leading) {
                    Text("Transaction Date")
                    DatePicker("Transaction Date", selection: $date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxHeight: 400)
                }
            }
            Button(action: {
                transactionListModelView.createTransactionRecord(transactiontType: isCredit ? .credit : .debit,
                                                                 date: date,
                                                                 amount: amount,
                                                                 merchant: merchant,
                                                                 account: account,
                                                                 category: selectedItems.first!)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Create Transaction")
                    .font(.subheadline)
            }
            .padding()
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .foregroundColor(Color.black)
            .background(Color.icon)
            .disabled(selectedItems.isEmpty && amount.isEmpty && merchant.isEmpty && account.isEmpty)
            
        }
        .background(Color.background)
        .listStyle(.insetGrouped)
    }
}

//MARK: GridColumn from transaction type
struct GridColumn:View {
    let item: Category
    
    @Binding var items: [Category]
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.icon.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay {
                    FontIcon.text(.awesome5Solid(code: item.icon), fontsize: 24, color: Color.icon)
                    
                }
                .padding(.top)
            Text(item.name)
                .frame(width: 80, height: 40, alignment: .center )
                .multilineTextAlignment(.center)
                .font(.system(.caption))
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(items.contains(where: {$0.id == item.id}) ? Color.background : Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
    }
}
