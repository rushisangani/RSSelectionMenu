//
//  AssociatedObjectExtension.swift
//
//  Copyright (c) 2017 Rushi Sangani
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import ObjectiveC.NSObjCRuntime

/// NSObject associated object
public extension NSObject {
    
    /// keys
    private struct AssociatedKeys {
        static var descriptiveName = "associatedObject"
    }
    
    /// set associated object
    @objc public func setAssociated(object: Any) {
        objc_setAssociatedObject(self, &AssociatedKeys.descriptiveName, object, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// get associated object
    @objc public func associatedObject() -> Any? {
        return objc_getAssociatedObject(self, &AssociatedKeys.descriptiveName)
    }
}

// convert to dictionary
public extension NSObject {
    
    // dictionary
    public func toDictionary(from classType: NSObject.Type) -> [String: AnyObject] {
        
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass = class_copyPropertyList(classType, &propertiesCount)
        let propertiesDictionary : NSMutableDictionary = NSMutableDictionary()
        
        for i in 0 ..< Int(propertiesCount) {
            let property = propertiesInAClass?[i]
            let strKey = NSString(utf8String: property_getName(property!)) as String?
            if let key = strKey {
                propertiesDictionary.setValue(self.value(forKey: key), forKey: key)
            }
        }
        return propertiesDictionary as! [String : AnyObject]
    }
}
