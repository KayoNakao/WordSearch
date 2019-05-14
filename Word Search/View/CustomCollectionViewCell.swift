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
        self.addSubview(letterLabel)
    }
    
    let letterLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear//UIColor.green
        label.font = UIFont.systemFont(ofSize: label.font.pointSize, weight: .thin)
        return label
    }()
    
     func setupSubview(label:UILabel, sender cell:UICollectionViewCell){
        let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: cell.frame.size.height*0.7)

        let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: cell.frame.size.width*0.7)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            heightConstraint, widthConstraint
            ])
    }
    
    
}
