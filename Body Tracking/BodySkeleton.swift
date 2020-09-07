//
//  BodySkeleton.swift
//  Body Tracking
//
//  Created by Artyom Mihailovich on 9/7/20.
//

import SwiftUI
import RealityKit
import ARKit

class BodySkeleton: Entity {
    var joints: [String: Entity] = [:]  //Joints names mapped
    
    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            
            var jointRadius: Float = 0.03
            var jointColor: UIColor = .lightGray
            
            let jointEntity = makeJoint(radius: jointRadius, color: jointColor)
            joints[jointName] = jointEntity
            self.addChild(jointEntity)
        }
        
        self.updatePositionJoint(with: bodyAnchor)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func makeJoint(radius: Float, color: UIColor) -> Entity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, roughness: 0.8, isMetallic: false)
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        
        return modelEntity
    }
    
    func updatePositionJoint(with bodyAnchor: ARBodyAnchor){
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            if let jointEntity = joints[jointName], let jointTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName)) {
                let jointOffset = simd_make_float3(jointTransform.columns.3)
                
                jointEntity.position = rootPosition + jointOffset
                jointEntity.orientation = Transform(matrix: jointTransform).rotation
            }
        }
    }
}
