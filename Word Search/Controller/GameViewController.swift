//
//  ViewController.swift
//  Word Search
//
//  Created by 中尾 佳代 on 2019/05/10.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var level: Level!
    var screenSize = CGRect()
    
    let colors:[UIColor] = [UIColor.magenta, UIColor.green, UIColor.yellow]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Level " + level.level
        collectionView.backgroundColor = UIColor.blue
        
        screenSize = UIScreen.main.bounds
        collectionView.contentSize = CGSize(width: screenSize.size.width, height: screenSize.size.height)
        
    }


}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return level.grid * level.grid
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath)
        
        cell.backgroundColor = UIColor.red
        
        for view in cell.subviews{
            if let label = view as? UILabel{
                let index = Int(arc4random_uniform(3))
                label.backgroundColor = colors[index]
            }
        
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width:CGFloat = collectionView.contentSize.width / CGFloat(level.grid)
        
        return CGSize(width: width, height: width)
    }
    
    
}

