//
//  GeometryScrollView.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 31/05/2022.
//

import SwiftUI


/// ScrollView returning its offset through a Binding.
/// Inspired from the Alessandro Manilii article on Medium :
/// https://betterprogramming.pub/swiftui-calculate-scroll-offset-in-scrollviews-c3b121f0b0dc
struct GeometryScrollView<T: View>: View {

    let axes: Axis.Set
    let showsIndicators: Bool
    @Binding var offset: CGPoint
    let content: T
    
    init(_ axes: Axis.Set = .vertical,
         showsIndicators: Bool = true,
         offset: Binding<CGPoint> = .constant(.zero),
         @ViewBuilder content: () -> T
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self._offset = offset
        self.content = content()
    }
    
    var body: some View {
            ScrollView(axes, showsIndicators: showsIndicators) {
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: OffsetPreferenceKey.self,
                        value: proxy.frame(
                            in: .named("ScrollViewOrigin")
                        ).origin
                    )
                }
                .frame(width: 0, height: 0)
                content
            }
            .coordinateSpace(name: "ScrollViewOrigin")
            .onPreferenceChange(OffsetPreferenceKey.self,
                                perform: onOffsetChanged)
    }
    
    private func onOffsetChanged(offset: CGPoint) {
        self.offset = offset
    }
}


private struct OffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}


fileprivate struct GeometryScrollView_Previews_Container: View {
    @State private var offset = CGPoint.zero
    var body: some View {
        GeometryScrollView(.vertical, showsIndicators: false, offset: $offset) {
            Text("ScrollView content")
        }
        .safeAreaInset(edge: .bottom) {
            Text("Offset: \(String(format: "%.2f", offset.y))")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.yellow)
        }
    }
}

struct GeometryScrollView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryScrollView_Previews_Container()
    }
}
