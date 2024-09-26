//
//  ContentView.swift
//  SERVER
//
//  Created by Daffashiddiq on 22/09/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: NavigationRouter
    let viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("LostMen-Yama-SERVER")
            Text("Connecting...")
            
            Button {
                viewModel.startConnecting()
            } label: {
                Text("START")
            }

        }
        .padding()
    }
}

extension ContentView {
    class ViewModel {
        
        func startConnecting() {
//            NetworkService.shared.startConnecting()
            let mqttmanager = MQTTManager()
            mqttmanager.connect()
        }
    }
}

#Preview {
    ContentView()
}
