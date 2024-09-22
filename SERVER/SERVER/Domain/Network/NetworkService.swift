//
//  NetworkService.swift
//  SERVER
//
//  Created by Daffashiddiq on 22/09/24.
//

import MultipeerConnectivity

final class NetworkService: NSObject, ObservableObject {
    
    static let shared = NetworkService()
    
    private let serviceType = "lostmen-peer"
    private let localPeerId: MCPeerID
    private let localSession: MCSession
    private let browserSession: MCNearbyServiceBrowser
    private let maxNumberPeers = 1
    
    @Published var isConnected = false
    
    var phonePeerIds: [MCPeerID: ClientState] = [:]
    
    override init() {
        self.localPeerId = MCPeerID(displayName: UIDevice.current.name)
        self.localSession = MCSession(peer: localPeerId)
        self.browserSession = MCNearbyServiceBrowser(peer: localPeerId, serviceType: serviceType)
        
        super.init()
        
        self.localSession.delegate = self
        self.browserSession.delegate = self
    }
    
    func startConnecting() {
        self.browserSession.startBrowsingForPeers()
    }
    
    func stopConnecting() {
        self.browserSession.stopBrowsingForPeers()
    }
    
    func sendPhoneRole(clientData: ClientState) {
        do {
            let jsonData = try JSONEncoder().encode(clientData)
            try localSession.send(jsonData, toPeers: localSession.connectedPeers, with: .reliable)
        } catch {
            print("Error sendPhoneRole with error: \(error.localizedDescription)")
        }
    }
    
    private func updatePhoneState(_ peerId: MCPeerID, with clientState: ClientState) {
        self.phonePeerIds[peerId] = clientState
    }
}

extension NetworkService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("NetworkService didChange: \(state), from: \(peerID)")
        
        switch state {
        case .notConnected:
            print("notConnected to: \(peerID.displayName)")
        case .connecting:
            break
        case .connected:
            DispatchQueue.main.async {
                self.isConnected = true
            }
            if localSession.connectedPeers.count < maxNumberPeers {
                self.stopConnecting()
            }
        @unknown default:
            fatalError("Not Handled for now")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("NetworkService didReceive: \(data), from: \(peerID)")
        
        do {
            let packetFromPhone = try JSONDecoder().decode(ClientState.self, from: data)
            updatePhoneState(peerID, with: packetFromPhone)
            print("packetFromIpad: \(packetFromPhone)")
        } catch {
            print("Error decoding packet with: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("NetworkService didReceive: \(stream), withName: \(streamName), from: \(peerID)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("NetworkService didStartReceivingResourceWithName: \(resourceName), from: \(peerID), with: \(progress)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        print("NetworkService didFinishReceivingResourceWithName: \(resourceName), from: \(peerID)")
    }
    
    
}

extension NetworkService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Nearby browser foundPeer: \(peerID), withDiscoveryInfo: \(String(describing: info))")
        
        if localSession.connectedPeers.count < maxNumberPeers {
            browser.invitePeer(peerID, to: localSession, withContext: nil, timeout: 600)
        } else {
            browser.stopBrowsingForPeers()
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Nearby browser lostPeer: \(peerID)")
    }
}
