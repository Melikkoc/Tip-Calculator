import SwiftUI

// Define a SwiftUI view for the Tip Calculator
struct TipCalculatorView: View {
    // Define state variables to store user input
    @State private var billAmount = ""             // Stores the bill amount entered by the user
    @State private var tipPercentage = 0          // Stores the selected tip percentage
    @State private var customTipAmount = ""        // Stores the custom tip amount entered by the user
    @State private var numberOfPeople = 1          // Stores the number of people to split the bill
    
    // Flags to track whether a non-numeric value is entered for bill amount and custom tip amount
    @State private var isInvalidBillAmountEntered = false
    @State private var isInvalidCustomTipAmountEntered = false
    
    // Calculate the tip amount based on user input
    var tipAmount: Double {
        let bill = Double(billAmount) ?? 0 // Convert bill amount string to Double or default to 0
        let tipValue: Double
        // Check if a custom tip amount is entered, otherwise calculate tip based on percentage
        if !customTipAmount.isEmpty {
            tipValue = Double(customTipAmount) ?? 0 // Convert custom tip amount string to Double or default to 0
        } else {
            tipValue = bill * Double(tipPercentage) / 100 // Calculate tip based on bill amount and tip percentage
        }
        return tipValue // Return the calculated tip amount
    }
    
    // Calculate the total bill amount including tip
    var totalAmount: Double {
        let bill = Double(billAmount) ?? 0 // Convert bill amount string to Double or default to 0
        let total = bill + tipAmount // Calculate total bill amount by adding bill amount and tip amount
        return total // Return the total bill amount
    }
    
    // Calculate the total bill amount per person
    var totalPerPerson: Double {
        let total = totalAmount // Calculate the total bill amount including tip
        let people = Double(numberOfPeople) // Convert the number of people to Double
        let perPerson = total / people // Calculate the amount per person by dividing total by the number of people
        return perPerson.isNaN ? 0 : perPerson  // Return 0 if calculation results in NaN (Not a Number)
    }
    
    // Define available tip percentages
    let tipPercentages = [0, 5, 10, 15, 20, 25]
    
    var body: some View {
        VStack {
            Spacer() // Add space at the top
            
            // Create a form for user input
            Form {
                // Section for entering the bill amount
                Section(header: Text("Bill Amount")) {
                    TextField("Enter Bill Amount", text: $billAmount)
                        .keyboardType(.decimalPad) // Allow only numeric input with decimal pad
                        .padding()
                        .onChange(of: billAmount) { newValue, _ in
                            // Check if the entered value can be converted to a valid number
                            if let _ = Double(newValue) {
                                isInvalidBillAmountEntered = false
                            } else {
                                isInvalidBillAmountEntered = true
                            }
                        }
                }
                // Display warning if a non-numeric value is entered for bill amount
                if isInvalidBillAmountEntered {
                    Text("Please enter a valid number")
                        .foregroundColor(.red)
                        .padding(.leading)
                }
                
                // Section for entering a custom tip amount
                Section(header: Text("Custom Tip Amount")) {
                    TextField("Enter Custom Tip Amount", text: $customTipAmount)
                        .keyboardType(.decimalPad) // Allow only numeric input with decimal pad
                        .padding()
                        .onChange(of: customTipAmount) { newValue, _ in
                            // Check if the entered value can be converted to a valid number
                            if let _ = Double(newValue) {
                                isInvalidCustomTipAmountEntered = false
                            } else {
                                isInvalidCustomTipAmountEntered = true
                            }
                        }
                }
                // Display warning if a non-numeric value is entered for custom tip amount
                if isInvalidCustomTipAmountEntered {
                    Text("Please enter a valid number")
                        .foregroundColor(.red)
                        .padding(.leading)
                }
                
                // Section for selecting tip percentage
                Section(header: Text("Tip Percentage")) {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        // Display tip percentage options in a segmented control
                        ForEach(tipPercentages, id: \.self) { percentage in
                            if percentage == 0 {
                                Text("No Tip") // Display "No Tip" for 0% tip
                            } else {
                                Text("\(percentage)%") // Display tip percentage
                            }
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle()) // Use segmented control style
                    .padding()
                    
                    // Display calculated tip amount if a percentage is selected
                    if tipPercentage != 0 {
                        Text("Tip Amount: $\(tipAmount, specifier: "%.2f")") // Format the value with two decimal places
                            .foregroundColor(.secondary) // Set text color to secondary
                            .padding(.leading)
                    }
                }
                
                // Section for selecting the number of people to split the bill
                Section(header: Text("Number of People")) {
                    // Create a stepper control for selecting the number of people
                    Stepper(value: $numberOfPeople, in: 1...Int.max, label: {
                        Text("Split Between \(numberOfPeople) People") // Display the number of people
                    })
                    .padding()
                }
                
                // Section for displaying total bill amounts
                Section(header: Text("Total")) {
                    Text("Total Amount: $\(totalAmount, specifier: "%.2f")") // Display total bill amount
                    Text("Total Per Person: $\(totalPerPerson, specifier: "%.2f")") // Format the value with two decimal places
                        .foregroundColor(.blue) // Set text color to blue
                }
            }
            
            Spacer() // Add space at the bottom
        }
        .navigationBarTitle("Tip Calculator") // Set navigation bar title
        .padding() // Add padding to the entire view
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea()) // Set background color
    }
}

// SwiftUI preview for the TipCalculatorView
struct TipCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        TipCalculatorView()
            .previewLayout(.sizeThatFits) // Set preview layout
    }
}

// Define a ContentView containing a TabView
struct ContentView: View {
    var body: some View {
        TabView {
            // Add TipCalculatorView as a tab item
            TipCalculatorView()
                .tabItem {
                    Image(systemName: "calculator") // Add calculator icon
                    Text("Tip Calculator") // Add text label
                }
        }
    }
}

// SwiftUI preview for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

