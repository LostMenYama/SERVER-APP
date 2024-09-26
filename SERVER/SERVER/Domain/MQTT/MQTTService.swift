//
//  MQTTService.swift
//  SERVER
//
//  Created by Daffashiddiq on 25/09/24.
//

import CocoaMQTT
import Foundation

class MQTTManager {
    
    var mqttClient: CocoaMQTT!
    
    init() {
        setupMQTTClient()
    }
    
    private func setupMQTTClient() {
        let clientID = "iPadClient-Test" + String(ProcessInfo().processIdentifier)
        mqttClient = CocoaMQTT(clientID: clientID, host: "localhost", port: 1883)
        mqttClient.keepAlive = 60
        mqttClient.logLevel = .debug
        mqttClient.cleanSession = false
        mqttClient.willMessage = CocoaMQTTMessage(topic: "/will", string: "die")
        
        mqttClient.username = ""
        mqttClient.password = ""
        
        mqttClient.delegate = self
    }
    
    func connect() {
        let connected = mqttClient.connect()
        print("Connection initiated: \(connected)")
    }
    
    func publishMessage() {
        if mqttClient.connState == .connected {
            mqttClient.publish("test/topic", withString: "Hello MQTT")
        } else {
            print("MQTT client is not connected")
        }
    }
}

extension MQTTManager: CocoaMQTTDelegate {
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("Connected with ack: \(ack.rawValue)")
        
        if ack == .accept {
            print("Connection accepted, subscribing to topic")
            
            // Delay subscription to ensure the connection is stable
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                mqtt.subscribe("test/topic", qos: .qos1)
            }
        } else {
            print("Connection failed with ack: \(ack.rawValue)")
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Received message on topic: \(message.topic), message: \(message.string ?? "")")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("Successfully subscribed to: \(success)")
        if !failed.isEmpty {
            print("Failed to subscribe to topics: \(failed)")
        }
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        if let error = err {
            print("Disconnected with error: \(error.localizedDescription)")
        } else {
            print("Disconnected gracefully")
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("MQTTManager didPublishMessage with id: \(id) and message: \(message)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("MQTTManager didPublishAck with id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("MQTTManager didUnsubscribeTopics from topics: \(topics)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("MQTTManager mqttDidPing")
    }

    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("MQTTManager mqttDidReceivePong")
    }
}
