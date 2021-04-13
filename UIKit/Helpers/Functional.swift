//
//  Functional.swift
//  ARKitStartApp
//
//  Created by Artyom Mihailovich on 3/9/21.
//

import Foundation

public protocol FunctionalWrapper {}

extension NSObject: FunctionalWrapper {}

public extension FunctionalWrapper {
    func `do`(_ mutator: (Self) -> Void) -> Self {
        mutator(self)
        return self
    }
}
