//
//  BrandRow.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 31/05/2022.
//

import SwiftUI

struct BrandRow: View {
    
    let brand: Brand
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            image(of: brand)
                .frame(width: 36, height: 36)
                .padding(8)
                .background(Color(uiColor: .systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay {
                    if !isSelected {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color(uiColor: .secondaryLabel), lineWidth: 0.2)
                    }
                }
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 3)
            Text(brand.name)
                .font(.headline)
                .foregroundColor(isSelected ? .white : Color(uiColor: .label))
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.trailing, 8)
            }
        }
        .padding(10)
        .background(isSelected ? .accentColor : Color(uiColor: .quaternarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            if !isSelected {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color(uiColor: .tertiaryLabel), lineWidth: 0.2)
            }
        }
        .animation(.strongBounce, value: isSelected)
    }
    
    @ViewBuilder
    func image(of brand: Brand) -> some View {
        if let name = brand.iconName {
            Image(name)
                .resizable()
                .scaledToFit()
        } else {
            AsyncImage(url: brand.iconURL) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
        }
    }
}

struct BrandRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            BrandRow(brand: .Tesla, isSelected: true)
            BrandRow(brand: .BMW, isSelected: false)
        }.padding()
    }
}
