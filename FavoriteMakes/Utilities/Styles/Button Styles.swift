//
//  Button Styles.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 30/05/2022.
//

import SwiftUI





struct PlainButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.footnote.weight(.bold))
            .padding(8)
            .padding(.horizontal, 8)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.strongBounce, value: configuration.isPressed)
    }
}



struct OutlinedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.footnote.weight(.bold))
            .padding(8)
            .padding(.horizontal, 8)
            .foregroundColor(Color(uiColor: .label))
            .overlay(Capsule().stroke(Color.secondary, lineWidth: 0.2))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.strongBounce, value: configuration.isPressed)
    }
}



struct SquaredButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.medium))
            .foregroundColor(Color(uiColor: .label))
            .padding(8)
            .background(Color(uiColor: .quaternarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.strongBounce, value: configuration.isPressed)
    }
}



struct BouncyButton: ButtonStyle {
    
    let scaleDown: Double
    
    init(scaleDown: Double = 0.98) {
        self.scaleDown = scaleDown
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleDown : 1)
            .animation(.strongBounce, value: configuration.isPressed)
    }
}







struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            Button("Plain button", action: {}).buttonStyle(PlainButton())
            Button("Outlined button", action: {}).buttonStyle(OutlinedButton())
            Button(action: {}, label: {
                Image(systemName: "plus")
            }).buttonStyle(SquaredButton())
            Button {
                
            } label: {
                Text("Plain button")
                    .font(.headline)
                    .padding(8)
                    .background(.tint)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
                .buttonStyle(BouncyButton())
        }
    }
}
