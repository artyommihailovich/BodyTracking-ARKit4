//
//  ARView.swift
//  BodyTracking
//
//  Created by Artyom Mihailovich on 6/16/21.
//

import ARKit
import RealityKit

extension ARView {
    func setupARConfiguration() {
        let configuration = ARBodyTrackingConfiguration()
        self.session.run(configuration)
    }
}
