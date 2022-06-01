//
//  HomeTitle.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 31/05/2022.
//

import SwiftUI

struct ViewTitles: View {
    
    let subtitle: String?
    let title: String?
    let caption: String?
    
    init(subtitle: String? = nil, title: String? = nil, caption: String? = nil) {
        self.subtitle = subtitle
        self.title = title
        self.caption = caption
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let subtitle = subtitle {
                Text(subtitle)
            }
            if let title = title {
                Text(title)
                    .fontWeight(.heavy)
            }
            if let caption = caption {
                Text(caption)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .font(.title2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .padding(.bottom)
        .padding(.horizontal)
    }
}

struct HomeTitle_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
