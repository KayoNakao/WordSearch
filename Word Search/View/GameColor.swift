//
//  GameColor.swift
//  Word Search
//
//  Created by 中尾 佳代 on 2019/05/13.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import UIKit


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    
    struct GameColor {
        static let GridYellow = UIColor(red: 250, green: 207, blue: 90)
        static let ChosenRed = UIColor(red: 255, green: 89, blue: 89)
        static let SelectGreen = UIColor(red: 73, green: 190, blue: 183)
    }
    
}
