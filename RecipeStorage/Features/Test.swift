//
//  Test.swift
//  RecipeStorage
//
//  Created by Nicolas Ströbel on 10.01.26.
//

import SwiftUI

struct Test: View {
    
    @State private var name: String = ""
    @State private var isOn: Bool = false
    
    var body: some View {
        Form {
            
            Section("Basis Daten") {
                TextField("Name von Nutzer", text: $name)
                
                Toggle("Einschalter", isOn: $isOn)
                
                if isOn {
                    Text("Name: \(name)")
                }
            }
            
            Section("Bilder") {
                Image("carbonara")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(100)
            }
            
        }
    }
}

#Preview {
    Test()
}
