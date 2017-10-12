//
//  CustomTableViewCell.swift
//  Example
//
//  Created by Rushi on 06/10/17.
//  Copyright © 2017 Rushi Sangani. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // set data
    func setData(_ person: Person) {
        
        idLabel.text = person.id.description
        firstNameLabel.text = person.firstName
        lastNameLabel.text = person.lastName
    }
    
}
