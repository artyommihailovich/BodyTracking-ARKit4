//
//  Stretch.metal
//  BodyTracking
//
//  Created by Artyom Mihailovich on 6/16/21.
//

#include <metal_stdlib>
#include "RealityKit/RealityKit.h"
using namespace metal;

[[visible]]
void stretch(realitykit::geometry_parameters parameters){
    float3 position = parameters.geometry().model_position();
    float offsetMult = sin(parameters.uniforms().time() * 3);
    parameters.geometry().set_model_position_offset(float3(position.x * offsetMult, position.y * offsetMult, position.z * offsetMult));
}

[[visible]]
void surface(realitykit::surface_parameters parameters) {
    auto surface = parameters.surface();
    float amplitude = 0.05;
    half3 color = half3(0.5, 0.5, 0);
    float height = (parameters.geometry().model_position().y + amplitude) / (amplitude * 2);
    surface.set_base_color(color + min(1.0f, pow(height, 8)) * (1 - color));
}
