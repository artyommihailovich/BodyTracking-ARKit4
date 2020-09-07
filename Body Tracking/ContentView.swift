//
//  ContentView.swift
//  Body Tracking
//
//  Created by Artyom Mihailovich on 9/7/20.
//

import SwiftUI
import RealityKit
import ARKit


var bodySkeleton: BodySkeleton?
var bodySkeletonAnchor = AnchorEntity()

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

// Make ARView
struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        arView.setupARConfiguration()
        arView.scene.addAnchor(bodySkeletonAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}



extension ARView: ARSessionDelegate {
    
    // Setup a body tracking configration.
    func setupARConfiguration() {
        let configuration = ARBodyTrackingConfiguration()
        self.session.run(configuration)
        
        self.session.delegate = self
    }
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor {
                /*
                print("Update bodyAnchor")

                let skeleton = bodyAnchor.skeleton

                let rootJointTransform = skeleton.modelTransform(for: .root)!
                let rootJointPosition = simd_make_float3(rootJointTransform.columns.3)
                print("Root: \(rootJointPosition)")


                let leftHandTransform = skeleton.modelTransform(for: .leftHand)!
                let leftHandOffset = simd_make_float3(leftHandTransform.columns.3)
                let leftHandPosition = rootJointPosition + leftHandOffset
                print("Left hand position: \(leftHandPosition)")
                */
                
                if let skeleton = bodySkeleton {
                    // BodySkeleton already excists, update pose of all joints.
                    skeleton.updatePositionJoint(with: bodyAnchor)
                } else {
                    // Seeing body at first time, make the BodySkeleton.
                    let skeleton = BodySkeleton(for: bodyAnchor)
                    bodySkeleton = skeleton
                    bodySkeletonAnchor.addChild(skeleton)
                }
            }
        }
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
