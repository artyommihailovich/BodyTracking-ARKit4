//
//  Skeleton.swift
//  BodyTracking
//
//  Created by Artyom Mihailovich on 1/24/21.
//

import ARKit
import RealityKit

final class BodySkeleton: Entity { 
    private var joints: [String: Entity] = [:]
    private var entity: ModelEntity!
    
    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            let jointColor: UIColor = .lightGray
            let jointEntity = makeEntity(color: jointColor)
            joints[jointName] = jointEntity
            self.addChild(jointEntity)
        }
        self.updatePositionJoint(with: bodyAnchor)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func makeEntity(color: UIColor) -> Entity {
        let mtlLibrary = MTLCreateSystemDefaultDevice()!.makeDefaultLibrary()!
        let geometryModifier = CustomMaterial.GeometryModifier(named: "stretch", in: mtlLibrary)
        let surfaceShader = CustomMaterial.SurfaceShader(named: "surface", in: mtlLibrary)
        var material = PhysicallyBasedMaterial()
        
        material.baseColor.texture = MaterialParameters.Texture(try! .load(named: "baseColor"))
        material.normal.texture = MaterialParameters.Texture(try! .load(named: "normal"))
        material.roughness.texture = MaterialParameters.Texture(try! .load(named: "roughness"))
        material.metallic.texture = MaterialParameters.Texture(try! .load(named: "metallic"))

        entity = ModelEntity(mesh: .generateSphere(radius: 0.07), materials: [material])

        entity.model?.materials = entity.model?.materials.map {
            try! CustomMaterial(from: $0, surfaceShader: surfaceShader,
                                geometryModifier: geometryModifier)
        } ?? [Material]()
        
        entity.model?.materials = entity.model?.materials.map {
            try! CustomMaterial(from: $0, geometryModifier: geometryModifier)
        } ?? [Material]()
        
        return entity
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
