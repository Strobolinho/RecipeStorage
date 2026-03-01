//
//  TwoDecimalPicker.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 26.02.26.
//

import SwiftUI

struct TwoDecimalPicker: View {

    @Binding var value: Double

    var intRange: ClosedRange<Int> = 0...100

    @State private var integerPart: Int = 0

    // Wrap-around wheel config
    private let decimals = Array(stride(from: 0, through: 95, by: 5))
    private let repeats = 7                 // ungerade Zahl ist praktisch
    private var totalDecimalItems: Int { decimals.count * repeats }
    private var middleOffset: Int { (repeats / 2) * decimals.count }

    @State private var decimalSelectionIndex: Int = 0 // 0..<(100*repeats)

    var body: some View {
        HStack(spacing: 0) {

            // Ganzzahl
            Picker("Integer", selection: $integerPart) {
                ForEach(intRange, id: \.self) { n in
                    Text("\(n)").tag(n)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)

            // Komma sichtbar
            Text(",")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 20)
                .accessibilityHidden(true)

            // Nachkommastellen (00–99), "wrap-around" via Repeats
            Picker("Decimal", selection: $decimalSelectionIndex) {
                ForEach(0..<totalDecimalItems, id: \.self) { i in
                    let d = decimals[i % decimals.count]
                    Text(String(format: "%02d", d))
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
        }
        .onAppear { splitInitialValue() }
        .onChange(of: integerPart) { _ in updateValue() }
        .onChange(of: decimalSelectionIndex) { old, new in
            recenterDecimalWheelIfNeeded(old: old, new: new)
            updateValue()
        }
    }

    private var decimalPart: Int {
        decimals[((decimalSelectionIndex % decimals.count) + decimals.count) % decimals.count]
    }

    private func updateValue() {
        value = Double(integerPart) + Double(decimalPart) / 100.0
    }

    private func splitInitialValue() {
        // integer
        integerPart = Int(value.rounded(.towardZero))

        // decimals (2 Stellen)
        let fractional = abs(value - Double(integerPart))
        let dec = Int((fractional * 20.0).rounded()) // 20 Steps pro Einheit
        let safeIndex = min(max(dec, 0), decimals.count - 1)
        decimalSelectionIndex = middleOffset + safeIndex
    }

    private func recenterDecimalWheelIfNeeded(old: Int, new: Int) {
        // Wenn du zu nah an die Ränder scrollst, springe in die Mitte (selber Wert mod 100)
        let threshold = 100 // 1 Block Abstand

        if new < threshold {
            decimalSelectionIndex = middleOffset + (new % 100)
        } else if new > totalDecimalItems - threshold {
            decimalSelectionIndex = middleOffset + (new % 100)
        }
    }
}
