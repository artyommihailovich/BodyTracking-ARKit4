//
//  ViewController.swift
//  BodyTracking
//
//  Created by Artyom Mihailovich on 1/24/21.
//

import UIKit
import RealityKit
import ARKit

final class ViewController: UIViewController {
    
    private let skeletonAnchor = AnchorEntity()
    private var bodySkeleton: BodySkeleton?

    private lazy var arView = ARView().do {
        $0.frame = view.bounds
        $0.session.delegate = self
        $0.setupARConfiguration()
        $0.scene.addAnchor(skeletonAnchor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(arView)
    }
}

extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor {
                if let skeleton = bodySkeleton {
                    skeleton.updatePositionJoint(with: bodyAnchor)
                } else {
                    let skeleton = BodySkeleton(for: bodyAnchor)
                    bodySkeleton = skeleton
                    skeletonAnchor.addChild(skeleton)
                }
            }
        }
    }
}
