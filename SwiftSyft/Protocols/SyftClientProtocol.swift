//
//  SyftProtocol.swift
//  Pods-SwiftSyft_Example
//
//  Created by Mark Jeremiah Jimenez on 20/01/2020.
//

import Foundation

/// Describes interface for syft client that coordinates signalling and peer-to-peer connection
protocol SyftClientProtocol {

    /// - Parameter url: PyGrid URL
    func newJob(modelName: String, version: String, inference: Bool) -> SyftJob
}

protocol SyftJobProtocol {

    var modelName: String { get }
    var version: String { get }
    var inference: Bool { get }

    /// Request to join a federated learning cycle at "model-centric/cycle-request" endpoint (https://github.com/OpenMined/PyGrid/issues/445)
    func start(chargeDetection: Bool, wifiDetection: Bool)

}
