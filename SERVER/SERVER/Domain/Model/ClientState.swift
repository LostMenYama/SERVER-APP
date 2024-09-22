//
//  ClientState.swift
//  SERVER
//
//  Created by Daffashiddiq on 22/09/24.
//

import Foundation

struct ClientState: Codable {
    var phoneRole: PhoneRole
    var currentState: Int // 0: pre-setup, 1: first-puzzle, 2: second-puzzle, 3: third-puzzle, 4: fourth-puzzle, 5: fifth-puzzle, 6: end-state
}

enum PhoneRole: String, Codable {
    case firstPhone
    case secondPhone
    case thirdPhone
    case notConfiguredYet
}
