//
//  ViewController.swift
//  Word Search
//
//  Created by 中尾 佳代 on 2019/05/10.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var level: Level!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Level " + level.level
    }


}

