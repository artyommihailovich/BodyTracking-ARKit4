//
//  Skeleton.swift
//  BodyTracking
//
//  Created by Artyom Mihailovich on 1/24/21.
//

import RealityKit
import ARKit

class BodySkeleton: Entity {
    
    var joints: [String: Entity] = [:]
    
    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            
            var jointRadius: Float = 0.07
            var jointColor: UIColor = .red
            
            switch jointName {
            case "neck_1_joint", "neck_2_joint", "neck_3_joint", "neck_4_joint", "head_joint", "left_shoulder_1_joint",
                 "right_shoulder_1_joint":
            jointRadius *= 0.5
            jointColor = .blue
                
            case "jaw_joint", "chin_joint", "left_eye_joint", "left_eyeLowerLid joint", "left_eyeUpperLid_joint",
                 "left_eyeball_joint", "nose_join;t", "right_eye_joint", "right_eyeLowerLid_joint", "right_eyeUpperLid_joint",
                 "right_eyeball_joint":
            jointRadius *= 0.8
            jointColor = .systemPink
                
            case _ where jointName.hasPrefix("spine_"):
                jointRadius *= 0.6
                jointColor = .white
                
            case "left_hand_joint", "right_hand_joint":
                jointRadius *= 0.2
                jointColor = .red
            default:
                break
            }
            
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
        var material = PhysicallyBasedMaterial()
        material.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: 1.8)
        material.baseColor = .init(tint: color)
        material.roughness = 0.4
        material.blending = .transparent(opacity: 0.4)
        material.anisotropyLevel = 0.8
        material.anisotropyAngle = 0.8
        material.sheen = .init(tint: .green)
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
