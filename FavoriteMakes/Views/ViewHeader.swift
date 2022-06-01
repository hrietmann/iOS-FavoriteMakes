//
//  HomeHeader.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 30/05/2022.
//

import SwiftUI

struct ViewHeader<LeadingItem: View, TrailingItem: View>: View {
    
    let title: String?
    let caption: String?
    private let leadingItem: (() -> LeadingItem)?
    private let trailingItem: (() -> TrailingItem)?
    @Binding var offset: CGPoint
    
    init(title: String? = nil, caption: String? = nil,
         scrollViewOffset: Binding<CGPoint> = .constant(.zero),
         @ViewBuilder leading leadingItem: @escaping () -> LeadingItem,
         @ViewBuilder trailing trailingItem: @escaping () -> TrailingItem) {
        self.title = title
        self.caption = caption
        self.leadingItem = leadingItem
        self.trailingItem = trailingItem
        _offset = scrollViewOffset
    }
    
    init(title: String? = nil, caption: String? = nil,
         scrollViewOffset: Binding<CGPoint> = .constant(.zero))
    where LeadingItem == EmptyView, TrailingItem == EmptyView {
        self.title = title
        self.caption = caption
        leadingItem = nil
        trailingItem = nil
        _offset = scrollViewOffset
    }
    
    var body: some View {
        HStack {
            if let leadingItem = leadingItem {
                leadingItem()
            }
            Spacer()
            if let trailingItem = trailingItem {
                trailingItem()
            }
        }
        .overlay {
            VStack(spacing: 0) {
                if let title = title {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                if let caption = caption {
                    Text(caption)
                        .font(.caption2)
                        .foregroundColor(Color(uiColor: .tertiaryLabel))
                }
            }
            .lineLimit(1)
            .padding(.horizontal, 80)
            .opacity(offset.y < -60 ? (offset.y + 60.0) / -30.0 : 0)
        }
        .padding(.top)
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
        .background {
            Color.white
                .padding(.top, -80)
                .overlay { Divider().frame(maxHeight: .infinity, alignment: .bottom) }
                .opacity(offset.y < 0 ? offset.y / -60.0 : 0)
        }
    }
}

struct HomeHeader_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
