//
//  SuggestionRow.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 30/05/2022.
//

import SwiftUI

struct SuggestionRow<Actions: View>: View {
    
    let title: LocalizedStringKey
    let message: LocalizedStringKey
    let actions: () -> Actions
    
    init(title: LocalizedStringKey, message: LocalizedStringKey, @ViewBuilder _ actions: @escaping () -> Actions) {
        self.title = title
        self.message = message
        self.actions = actions
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.headline.weight(.heavy))
                    Text(message)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                actions()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding()
            Divider()
        }
    }
}

struct SuggestionRow_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionRow(
            title: "Restez en contact avec vos visites.",
            message: "Activez les notifications pour ne obtenir des rappels intelligents."
        ) {
            Button("Activer les notifications") {
                
            }
            .buttonStyle(PlainButton())
            Button("Plus tard") {
                
            }
            .buttonStyle(OutlinedButton())
        }
    }
}
