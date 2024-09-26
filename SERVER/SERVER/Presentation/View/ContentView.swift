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
            
            Button {
                viewModel.publishMessage()
            } label: {
                Text("PUBLISH MESSAGE")
            }
        }
        .padding()
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        private var mqttManager: MQTTManager? // Retain the MQTTManager instance
        
        func startConnecting() {
            mqttManager = MQTTManager()  // Instantiate and retain the MQTTManager
            mqttManager?.connect()       // Connect to the MQTT broker
        }
        
        func publishMessage() {
            mqttManager?.publishMessage() // Publish a message using MQTTManager
        }
    }
}

#Preview {
    ContentView()
}
