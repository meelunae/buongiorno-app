//
//  View+Geometry.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-03-26.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension View {
    
    /**
        Bind the view's safe area to a binding.
     */
    func bindSafeAreaInsets(to binding: Binding<EdgeInsets>) -> some View {
        background(safeAreaBindingView(for: binding))
    }
    
    /**
        Bind the view's size to a binding.
    */
    func bindSize(to binding: Binding<CGSize>) -> some View {
        background(sizeBindingView(for: binding))
    }
    
    /**
        Bind the view's frame to a binding.
    */
    func bindFrame(to binding: Binding<CGRect>,
                   coordinateSpace: CoordinateSpace = .global) -> some View {
        background(frameBindingView(for: binding, coordinateSpace: coordinateSpace))
    }
}

private extension View {
    
    func changeStateAsync(_ action: @escaping () -> Void) {
        DispatchQueue.main.async(execute: action)
    }
    
    func safeAreaBindingView(for binding: Binding<EdgeInsets>) -> some View {
        GeometryReader { geo in
            self.safeAreaBindingView(for: binding, geo: geo)
        }
    }
    
    func safeAreaBindingView(for binding: Binding<EdgeInsets>, geo: GeometryProxy) -> some View {
        changeStateAsync { binding.wrappedValue = geo.safeAreaInsets }
        return Color.clear
    }
    
    func sizeBindingView(for binding: Binding<CGSize>) -> some View {
        GeometryReader { geo in
            self.sizeBindingView(for: binding, geo: geo)
        }
    }
    
    func sizeBindingView(for binding: Binding<CGSize>, geo: GeometryProxy) -> some View {
        changeStateAsync { binding.wrappedValue = geo.size }
        return Color.clear
    }
    
    func frameBindingView(for binding: Binding<CGRect>, coordinateSpace: CoordinateSpace = .global) -> some View {
        GeometryReader { geo in
            self.frameBindingView(for: binding, geo: geo, coordinateSpace: coordinateSpace)
        }
    }
    
    func frameBindingView(for binding: Binding<CGRect>, geo: GeometryProxy, coordinateSpace: CoordinateSpace) -> some View {
        changeStateAsync { binding.wrappedValue = geo.frame(in: coordinateSpace) }
        return Color.clear
    }
}
