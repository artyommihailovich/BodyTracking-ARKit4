//
//  ViewController.swift
//  BodyTracking
//
//  Created by Artyom Mihailovich on 1/24/21.
//

import UIKit
import RealityKit
import ARKit

var bodySkeleton: BodySkeleton?
var bodySkeletonAnchor = AnchorEntity()

class ViewController: UIViewController {

    lazy private var arView = ARView().do {
        $0.frame = view.bounds
        $0.setupARConfiguration()
        $0.scene.addAnchor(bodySkeletonAnchor)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(arView)
    }
}

extension ARView: ARSessionDelegate {
    
    func setupARConfiguration() {
        let configuration = ARBodyTrackingConfiguration()
        self.session.run(configuration)
        self.session.delegate = self
    }
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor {
                if let skeleton = bodySkeleton {
                    skeleton.updatePositionJoint(with: bodyAnchor)
                } else {
                    let skeleton = BodySkeleton(for: bodyAnchor)
                    bodySkeleton = skeleton
                    bodySkeletonAnchor.addChild(skeleton)
                }
            }
        }
    }
}


