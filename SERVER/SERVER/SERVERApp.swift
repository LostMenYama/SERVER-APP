//
//  SERVERApp.swift
//  SERVER
//
//  Created by Daffashiddiq on 22/09/24.
//

import SwiftUI

@main
struct SERVERApp: App {
    @ObservedObject var router = NavigationRouter()
    let navigationHandler = NavigationHandler()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                ContentView()
                    .navigationDestination(for: Destination.self) { navigationHandler.view(for: $0) }
            }
            .environmentObject(router)
        }
    }
}
