//
//  BottomSheetAction.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 22/12/19.
//  Copyright © 2019 Rushi Sangani. All rights reserved.
//

import Foundation
import UIKit
import RSSelectionMenuComponent

struct BottomSheetAction: Codable {
    
    // MARK: - Properties
    
    let iconName: String?
    let title: String
    
    // Image
    var image: UIImage? {
        guard let name = iconName else { return nil }
        return UIImage(named: name)
    }
}
