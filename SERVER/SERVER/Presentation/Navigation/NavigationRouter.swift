//
//  NavigationRouter.swift
//  SERVER
//
//  Created by Daffashiddiq on 22/09/24.
//

import SwiftUI

final class NavigationRouter: ObservableObject {
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
