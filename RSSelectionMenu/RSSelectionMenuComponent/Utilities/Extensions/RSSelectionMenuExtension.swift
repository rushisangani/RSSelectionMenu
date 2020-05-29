//
//  RSSelectionMenuExtension.swift
//  RSSelectionMenu
//
//  Copyright (c) 2019 Rushi Sangani
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
import UIKit

/// UniquePropertyDelegate
public protocol UniquePropertyDelegate {
    
    /// Get model's unique value property name as string
    func getUniquePropertyName() -> String
}


/// RSSelectionMenu
extension RSSelectionMenu {
    
    /// Check if object is inside the datasource
    public func containsObject<T>(_ object: T, inDataSource dataSource: DataSource<T>) -> Bool {
        return (isSelected(item: object, from: dataSource) != nil)
    }
    
    
    /// Check if item is selected
    public func isSelected<T>(item: T, from: DataSource<T>) -> Int? {
        
        // item type is string
        if item is NSString {
            let hashValue = (item as! NSString).hashValue
        
            return from.firstIndex(where: { (data) -> Bool in
                return hashValue == (data as! NSString).hashValue
            })
        }
            
        // number type objects
        else if item is NSNumber {
            let hashValue = (item as! NSNumber).hashValue
            
            return from.firstIndex(where: { (data) -> Bool in
                return hashValue == (data as! NSNumber).hashValue
            })
        }
        
        // dictionary type
        else if item is NSDictionary {
            guard let key = uniquePropertyName else {
                fatalError("unique key is required to identify each dictionary uniquely.")
            }
            return hasSameValue(forKey: key, object: (item as! Dictionary), inArray: from)
        }
    
        // custom type
        else {
            
            if (uniquePropertyName == nil) && !(T.self is UniquePropertyDelegate.Type) {
                fatalError("NSObject subclass must implement UniqueProperty protocol or specify an uniquePropertyName to identify each object uniquely.")
            }
            
            let key = (T.self is UniquePropertyDelegate.Type) ? (item as! UniquePropertyDelegate).getUniquePropertyName() : uniquePropertyName!
            let dictionary: [String: Any] = (item is Decodable) ? (item as! Decodable).toDictionary() : (item as! NSObject).toDictionary()

            return hasSameValue(forKey: key, object: dictionary, inArray: from)
        }
    }
    
    
    /// Dictionary key value comparision that indetifies similar value's index
    public func hasSameValue<T>(forKey key: String, object: [String: Any], inArray: DataSource<T>) -> Int? {
        let value = String(describing: object[key])
        
        return inArray.firstIndex(where: { (data) -> Bool in
            let dictionary = (data is Decodable) ? (data as! Decodable).toDictionary() : (data as! NSObject).toDictionary()
            return value == String(describing: dictionary[key])
        })
    }
}
