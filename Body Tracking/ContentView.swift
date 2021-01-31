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
    
    func setupARConfiguration() {
        let configuration = ARBodyTrackingConfiguration()
        self.session.run(configuration)
        
        self.session.delegate = self
    }
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor {

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
