//
//  Test.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 11.01.26.
//

import SwiftUI

struct ControlsPlaygroundView: View {

    // MARK: - State
    @State private var toggleOn = true
    @State private var toggle2On = false

    @State private var stepperValue = 75
    @State private var sliderValue: Double = 50

    @State private var segmented = 0
    @State private var pickerSelection = "Proteinreich"
    @State private var multiPickerSelection = Set<String>()

    @State private var text = ""
    @State private var numberText = ""
    @State private var password = ""

    @State private var date = Date()

    @State private var showAlert = false
    @State private var showConfirm = false
    @State private var showSheet = false

    @State private var listItems = ["Lasagne", "Curry", "Salat", "Bowl"]

    private let categories = ["Proteinreich", "Kalorienarm", "Low-Carb", "Low-Fat"]

    var body: some View {
        NavigationStack {
            Form {

                // MARK: - Buttons
                Section("Buttons") {
                    Button("Primary Action") {
                        showAlert = true
                    }

                    Button(role: .destructive) {
                        showConfirm = true
                    } label: {
                        Text("Destructive Action")
                    }

                    Button {
                        showSheet = true
                    } label: {
                        Label("Open Sheet", systemImage: "square.and.arrow.up")
                    }

                    // Prominent style
                    Button("Prominent Button") { }
                        .buttonStyle(.borderedProminent)

                    Button("Bordered Button") { }
                        .buttonStyle(.bordered)

                    // Menu button
                    Menu {
                        Button("Option A") { }
                        Button("Option B") { }
                        Divider()
                        Button(role: .destructive) { } label: { Text("Delete") }
                    } label: {
                        Label("Menu", systemImage: "ellipsis.circle")
                    }
                }

                // MARK: - Toggles
                Section("Toggles") {
                    Toggle("Toggle", isOn: $toggleOn)

                    Toggle(isOn: $toggle2On) {
                        VStack(alignment: .leading) {
                            Text("Toggle with subtitle")
                            Text("Secondary text")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Toggle style switch (default) is already fine on iOS,
                    // but you can force:
                    Toggle("Switch Style Toggle", isOn: $toggleOn)
                        .toggleStyle(.switch)
                }

                // MARK: - Stepper & Slider
                Section("Stepper & Slider") {
                    Stepper("Stepper: \(stepperValue)", value: $stepperValue, in: 0...200, step: 5)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Slider: \(Int(sliderValue))")
                        Slider(value: $sliderValue, in: 0...100, step: 1)
                    }
                }

                // MARK: - Pickers
                Section("Pickers") {
                    Picker("Default Picker", selection: $pickerSelection) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }

                    Picker("Segmented", selection: $segmented) {
                        Text("A").tag(0)
                        Text("B").tag(1)
                        Text("C").tag(2)
                    }
                    .pickerStyle(.segmented)

                    // Multi selection (iOS 16+). Works best inside a List,
                    // but it’s still usable in Form.
                    NavigationLink("Multi-Select Example") {
                        List(categories, id: \.self, selection: $multiPickerSelection) { cat in
                            Text(cat)
                        }
                        .environment(\.editMode, .constant(.active)) // always show multi-select
                        .navigationTitle("Select Categories")
                    }
                }

                // MARK: - Text Inputs
                Section("Text Inputs") {
                    TextField("TextField", text: $text)

                    TextField("Numbers only", text: $numberText)
                        .keyboardType(.numberPad)

                    SecureField("SecureField", text: $password)

                    TextEditor(text: $text)
                        .frame(minHeight: 80)
                }

                // MARK: - Date / Time
                Section("Date & Time") {
                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                    DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }

                // MARK: - Gestures, Context Menus, Swipe Actions
                Section("List Interactions") {
                    ForEach(listItems, id: \.self) { item in
                        HStack {
                            Text(item)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // tap action
                        }
                        .contextMenu {
                            Button("Duplicate") { }
                            Button(role: .destructive) {
                                listItems.removeAll { $0 == item }
                            } label: {
                                Text("Delete")
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                listItems.removeAll { $0 == item }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                // e.g. favorite
                            } label: {
                                Label("Favorite", systemImage: "star")
                            }
                            .tint(.yellow)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                // e.g. pin
                            } label: {
                                Label("Pin", systemImage: "pin")
                            }
                            .tint(.blue)
                        }
                    }
                    .onMove { from, to in
                        listItems.move(fromOffsets: from, toOffset: to)
                    }
                }

                // MARK: - Navigation / Links
                Section("Navigation") {
                    NavigationLink("Push Detail View") {
                        VStack(spacing: 12) {
                            Text("Detail View")
                                .font(.title2)
                            Text("Put any control patterns here.")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .navigationTitle("Detail")
                    }

                    Link("Open Apple (external link)", destination: URL(string: "https://apple.com")!)
                }
            }
            .navigationTitle("Controls Playground")
            .toolbar {
                EditButton() // enables list reorder in the section above
            }
            .alert("Alert Title", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
                Button("Do Something") { }
            } message: {
                Text("This is a standard alert message.")
            }
            .confirmationDialog("Are you sure?", isPresented: $showConfirm, titleVisibility: .visible) {
                Button("Delete", role: .destructive) { }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This is a confirmation dialog.")
            }
            .sheet(isPresented: $showSheet) {
                NavigationStack {
                    VStack(spacing: 16) {
                        Text("Sheet")
                            .font(.title2)
                        Button("Close") {
                            showSheet = false
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .navigationTitle("Sheet")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}


#Preview {
    ControlsPlaygroundView()
}
