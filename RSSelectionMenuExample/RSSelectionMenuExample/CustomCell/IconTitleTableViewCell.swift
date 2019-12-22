//
//  IconTitleTableViewCell.swift
//  RSSelectionMenuExample
//
//  Created by Rushi Sangani on 22/12/19.
//  Copyright © 2019 Rushi Sangani. All rights reserved.
//

import UIKit

class IconTitleTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    private let iconWidth = 25
    
    // MARK: - View Components

    // Icon
    lazy var iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.darkGray
        return imageView
    }()
    
    // Title
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = UIColor.darkText
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViewComponents()
        
        accessoryType = .none
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage?, title: String?) {
        titleLabel.text = title
        iconView.image = image
        
        updateVisibility()
    }
}

// MARK: - Private

private extension IconTitleTableViewCell {
    
    func setupViewComponents() {
        
        // Main Stack
        let mainStackView = UIStackView(arrangedSubviews: [iconView, titleLabel])
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fill
        mainStackView.spacing = 20
        mainStackView.alignment = .center
        
        contentView.addSubview(mainStackView)
        
        [iconView, mainStackView].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let constraints = [
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mainStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            mainStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            iconView.widthAnchor.constraint(equalToConstant: CGFloat(iconWidth)),
            iconView.heightAnchor.constraint(equalToConstant: CGFloat(iconWidth))
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func updateVisibility() {
        titleLabel.isHidden = (titleLabel.text == nil)
        iconView.isHidden = (iconView.image == nil)
    }
}
