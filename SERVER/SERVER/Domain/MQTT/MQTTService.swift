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
//        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
//        mqttClient = CocoaMQTT5(clientID: clientID, host: "localhost", port: 1883)
//
//        let connectProperties = MqttConnectProperties()
//        connectProperties.topicAliasMaximum = 0
//        connectProperties.sessionExpiryInterval = 0
//        connectProperties.receiveMaximum = 100
//        connectProperties.maximumPacketSize = 500
//        mqttClient?.connectProperties = connectProperties

//        mqttClient?.username = "test"
//        mqttClient?.password = "public"
//        mqttClient?.willMessage = CocoaMQTT5Message(topic: "test/topic", string: "alslasl")
//        mqttClient?.keepAlive = 60
//        mqttClient?.delegate = self
//        mqttClient?.connect()
//        
//        mqttClient?.didReceiveMessage = { mqtt, message, id, dunno in
//            print("Message received in topic \(message.topic) with payload \(message.string!)")
//        }
        // Set MQTT broker details
        let clientID = "iPadClient-Test" + String(ProcessInfo().processIdentifier)
        mqttClient = CocoaMQTT(clientID: clientID, host: "broker.hivemq.com", port: 1883)
        mqttClient.keepAlive = 60
        mqttClient.logLevel = .debug
        mqttClient.cleanSession = false
        mqttClient.willMessage = CocoaMQTTMessage(topic: "/will", string: "die")

//         Set credentials if needed
        mqttClient.username = ""
        mqttClient.password = ""

//         Set the delegate to receive MQTT events
        mqttClient.delegate = self

//         Connect to the MQTT broker
//        let connectStatus = mqttClient.connect()
//        print("setupMQTTClient connectStatus with status: \(String(describing: connectStatus))")
        mqttClient.subscribe("test/topic", qos: .qos0)
    }

    // Send a message to a topic
    func connect() {
        _ = mqttClient.connect()
    }
    func publishMessage() {
        mqttClient?.publish("test/topic", withString: "Hello MQTT")
    }
}

//extension MQTTManager: CocoaMQTT5Delegate {
//    func mqtt5(_ mqtt5: CocoaMQTT5, didConnectAck ack: CocoaMQTTCONNACKReasonCode, connAckData: MqttDecodeConnAck?) {
//        
//    }
//    
//    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishMessage message: CocoaMQTT5Message, id: UInt16) {
//        
//    }
//    
//    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishAck id: UInt16, pubAckData: MqttDecodePubAck?) {
//        
//    }
//    
//    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishRec id: UInt16, pubRecData: MqttDecodePubRec?) {
//        
//    }
//    
//    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, publishData: MqttDecodePublish?) {
//        
//    }
//    
//    func mqtt5(_ mqtt5: CocoaMQTT5, didSubscribeTopics success: NSDictionary, failed: [String], subAckData: MqttDecodeSubAck?) {
//        
//    }
//    
//    func mqtt5(_ mqtt5: CocoaMQTT5, didUnsubscribeTopics topics: [String], unsubAckData: MqttDecodeUnsubAck?) {
//        
//    }
//    
//    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveDisconnectReasonCode reasonCode: CocoaMQTTDISCONNECTReasonCode) {
//        
//    }
//    
//    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveAuthReasonCode reasonCode: CocoaMQTTAUTHReasonCode) {
//        
//    }
//    
//    func mqtt5DidPing(_ mqtt5: CocoaMQTT5) {
//        
//    }
//    
//    func mqtt5DidReceivePong(_ mqtt5: CocoaMQTT5) {
//        
//    }
//    
//    func mqtt5DidDisconnect(_ mqtt5: CocoaMQTT5, withError err: (any Error)?) {
//        
//    }
//    
//    
//}

extension MQTTManager: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("Connected with ack: \(ack)")

        if ack == .accept {
            // Subscribe to a topic once connected
            mqtt.subscribe("test/topic")
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("MQTTManager didPublishMessage with id: \(id) and message: \(message)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("MQTTManager didPublishAck with id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("MQTTManager Message received on topic \(message.topic): \(message.string ?? "")")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("MQTTManager didSubscribeTopics with success: \(success) and failed: \(failed)")
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
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: (any Error)?) {
        if let error = err {
            print("MQTTManager Disconnected with error: \(error.localizedDescription)")
        } else {
            print("MQTTManager Disconnected gracefully")
        }
    }
    
}
