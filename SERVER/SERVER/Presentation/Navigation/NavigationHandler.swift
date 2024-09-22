//
//  NavigationHandler.swift
//  SERVER
//
//  Created by Daffashiddiq on 22/09/24.
//

import SwiftUI

enum Destination: Hashable {
    case contentView
}

final class NavigationHandler {
    
    @ViewBuilder
    func view(for destination: Destination) -> some View {
        switch destination {
        case .contentView:
            ContentView()
        }
    }
}
