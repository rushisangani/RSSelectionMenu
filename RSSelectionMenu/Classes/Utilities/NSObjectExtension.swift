//
//  AssociatedObjectExtension.swift
//  RSSelectionMenu
//
//  Created by Rushi on 30/09/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import Foundation
import ObjectiveC.NSObjCRuntime

/// NSObject associated object
extension NSObject {
    
    /// keys
    private struct AssociatedKeys {
        static var descriptiveName = "associatedObject"
    }
    
    /// set associated object
    @objc func setAssociated(object: Any) {
        objc_setAssociatedObject(self, &AssociatedKeys.descriptiveName, object, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// get associated object
    @objc func associatedObject() -> Any? {
        return objc_getAssociatedObject(self, &AssociatedKeys.descriptiveName)
    }
}

// convert to dictionary
extension NSObject {
    
    // dictionary
    func toDictionary() -> [String: Any] {
        return NSObject.getAllPropertyValues(withNames: self) as? [String : Any] ?? [:]
    }
}
