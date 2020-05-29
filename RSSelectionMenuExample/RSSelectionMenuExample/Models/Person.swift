//
//  Person.swift
//  Example
//
//  Created by Rushi on 06/10/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import Foundation
import RSSelectionMenuComponent

/// Person
class Person: NSObject, UniquePropertyDelegate {
    
    // MARK: - Properties
    let id: Int
    let firstName: String
    let lastName: String

    init(id: Int, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
    
    // MARK: - UniquePropertyDelegate
    func getUniquePropertyName() -> String {
        return "id"
    }
}
