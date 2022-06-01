//
//  BrandsSelector.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 31/05/2022.
//

import SwiftUI



struct BrandsSelector: View {
    
    @Environment(\.dismiss) private var dismiss
    let subtitle = "Select Your"
    let title = "Favorite Makes"
    var caption: String { model.isLoadingBrands ? "Loading makes..." : "\(model.loadedBrands.count) available" }
    @State private var offset = CGPoint.zero
    @StateObject private var model: BrandsSelectorModel
    @State private var presentErrorAlert = false
    
    init(favorite brands: [Brand], completion: @escaping ([Brand]) -> ()) {
        _model = .init(wrappedValue: .init(favorite: brands, completion: completion))
    }
    
    var body: some View {
        GeometryScrollView(.vertical, showsIndicators: false, offset: $offset) {
            LazyVStack(alignment: .leading, spacing: 16, pinnedViews: .sectionHeaders) {
                Section {
                    ViewTitles(subtitle: subtitle, title: title, caption: caption)
                    if model.isLoadingBrands {
                        ProgressView()
                            .padding(.vertical, 100)
                            .frame(maxWidth: .infinity)
                            .transition(.opacity.combined(with: .offset(y: 60)))
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(model.loadedBrands) { brand in
                                Button {
                                    if let index = model.selected.firstIndex(of: brand) {
                                        model.selected.remove(at: index)
                                    } else {
                                        model.selected.insert(brand, at: 0)
                                    }
                                } label: {
                                    BrandRow(brand: brand, isSelected: model.selected.contains(brand))
                                }
                                .buttonStyle(BouncyButton())
                            }
                        }
                        .padding(24)
                        .disabled(model.isSavingFavorites)
                        .opacity(model.isSavingFavorites ? 0.4 : 1)
                        .transition(.opacity.combined(with: .offset(y: 60)))
                    }
                } header: {
                    ViewHeader(title: title, caption: caption, scrollViewOffset: $offset) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(SquaredButton())
                    } trailing: {
                        Button {
                            Task { await model.updateSelectedBrands() }
                        } label: {
                            if model.isSavingFavorites {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(model.saveButtonTitle ?? "Save")
                            }
                        }
                        .buttonStyle(PlainButton())
                        .accentColor(model.saveButtonColor)
                        .disabled(model.selected.isEmpty)
                        .disabled(model.isLoadingBrands)
                        .disabled(model.isSavingFavorites)
                        .disabled(model.saveButtonTitle == nil)
                        .transition(.opacity)
                        .onChange(of: model.isSaveSuccessful) { newValue in
                            guard newValue else { return }
                            dismiss()
                        }
                    }
                }
            }
        }
        .animation(.strongBounce, value: model.isLoadingBrands)
        .animation(.strongBounce, value: model.isSavingFavorites)
        .task {
            await model.loadRemoteBrands()
        }
        .onReceive(model.$isLoadingBrands) { _ in
            presentErrorAlert = model.anyError != nil
        }
        .onReceive(model.$isSavingFavorites) { _ in
            presentErrorAlert = model.anyError != nil
        }
        .alert(isPresented: $presentErrorAlert, error: model.anyError) { _ in
            // Buttons
        } message: { Text($0.message) }
    }
}


struct BrandsSelector_Previews: PreviewProvider {
    static var previews: some View {
        BrandsSelector(favorite: .init(Brand.dummies.prefix(2))) { selectedBrands in
            
        }
    }
}
