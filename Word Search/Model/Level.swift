//
//  Level.swift
//  Word Search
//
//  Created by 中尾 佳代 on 2019/05/10.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import Foundation

struct Level: Codable{
    let level:String
    let grid:Int
    let words:[String]
    var time:Int
}
