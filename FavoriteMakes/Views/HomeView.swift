//
//  HomeView.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 30/05/2022.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var model = HomeViewModel()
    @State private var offset = CGPoint.zero
    @State private var presentBrandsSelector = false
    @State private var presentAuthView = false
    private var caption: String? { model.favoriteBrands.isEmpty ? nil : "\(model.favoriteBrands.count) total" }
    
    var body: some View {
        GeometryScrollView(.vertical, showsIndicators: false, offset: $offset) {
            LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                
                Section {
                    ViewTitles(subtitle: "Your", title: "Favorite Makes", caption: caption)
                    HomeCommercialView()
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(model.favoriteBrands) { brand in
                            BrandRow(brand: brand, isSelected: false)
                        }
                    }
                    .padding(24)
                } header: {
                    ViewHeader(title: "Favorite Makes", caption: caption, scrollViewOffset: $offset) {
                        Button {
                            presentAuthView = true
                        } label: {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFill()
                                .padding(4)
                        }
                        .frame(width: 48, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 48 / 4, style: .continuous))
                        .buttonStyle(SquaredButton())
                        .sheet(isPresented: $presentAuthView) {
                            AuthView()
                        }
                    } trailing: {
                        Button {
                            presentBrandsSelector = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .buttonStyle(SquaredButton())
                        .sheet(isPresented: $presentBrandsSelector) {
                            BrandsSelector(favorite: model.favoriteBrands) { selectedBrands in
                                model.set(favorite: selectedBrands)
                            }
                        }
                    }

                }
            }
        }
        .environmentObject(model)
        .task {
            await model.loadFavoriteBrands()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
