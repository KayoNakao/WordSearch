//
//  CustomCollectionViewCell.swift
//  Word Search
//
//  Created by 中尾 佳代 on 2019/05/10.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
        required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    let letterLabel:UILabel = {
        let label = UILabel()
        label.text = "A"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = UIColor.yellow
        return label
    }()
    
    func setupViews(){
        self.addSubview(letterLabel)
        
        
        let heightConstraint = NSLayoutConstraint(item: letterLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.frame.size.height)
        
        let widthConstraint = NSLayoutConstraint(item: letterLabel, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.frame.size.width)

        NSLayoutConstraint.activate([
            letterLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            letterLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            heightConstraint, widthConstraint
            ])
        
        letterLabel.font = letterLabel.font.withSize(letterLabel.frame.size.width)

    }
    
    
    
}
