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
    var letters: [Letter] = []
    var letterAmount = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Level " + level.level
        letterAmount = level.grid * level.grid
        
        for num in 0...letterAmount-1{
            let word = Letter(wordId: num, isSet: false, letter:"")
            letters.append(word)
        }
        
        screenSize = UIScreen.main.bounds
        collectionView.contentSize = CGSize(width: screenSize.size.width, height: screenSize.size.height)
        
        setWords()
        
    }


    func setWords(){
        
        for word in level.words{
 
            var array:[Letter] = []
            let characters = Array(word)
            
            var keep = true
            
            while keep {
                var i = 0
                var startNum = Int.random(in: 0 ..< letterAmount)
                var direction = getDirection()
                if characters.count >= level.grid {
                    let remind = startNum % 10
                    startNum = startNum + (level.grid - remind)
                    if startNum >= letterAmount {
                        startNum = startNum - letterAmount - level.grid
                    }
                    direction = 1
                }
                
                for char in characters{
                    var letter:Letter
                    if i != 0 {
                        let remaind = (startNum + direction*i) % level.grid
                        let checked = checkDirection(direction: direction, remind: remaind)
                        
                        
                        if startNum + direction*i < 0 || startNum + direction*i >= letterAmount || checked {
                            resetLetters(array: array)
                            array = []
                            break
                        }else {
                            letter = letters[startNum+direction*i]
                        }
                    }else {
                        letter = letters[startNum]
                    }
                    
                    if !letter.isSet{
                        letter.isSet = true
                        letter.letter = String(char)
                        letters[letter.wordId] = letter
                        print("letter: \(letter.wordId), \(letter.letter)")
                        
                        array.append(letter)
                        
                        if i == characters.count-1{
                            keep = false
                        }
                        i += 1
                    }else {
                        resetLetters(array: array)
                        array = []
                        direction = getDirection()
                        break
                    }
                }
            }
        }
    }

    func getDirection()-> Int{
        
        var num = Int.random(in: 0 ... 7)
        
        switch num {
        case 0: num = -level.grid - 1
        case 1: num = -level.grid
        case 2: num = -level.grid + 1
        case 3: num = -1
        case 4: num = 1
        case 5: num = level.grid - 1
        case 6: num = level.grid
        case 7: num = level.grid + 1
        default: num = 1
        }
        
        return num
    }
    
    func checkDirection(direction:Int, remind:Int)->Bool{
        
        print("remeind: \(remind)")
        switch direction {
        case -1, -1-level.grid, level.grid-1: if remind == level.grid-1 {return true}
        case 1, 1+level.grid, -level.grid+1: if remind == 0 {return true}
        
        default: return false
        }
        return false
    }
    
    func resetLetters(array:[Letter]){
        
        for var letter in array{
            letter.isSet = false
            letter.letter = ""
            letters[letter.wordId] = letter
        }
    }
    
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letterAmount
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath)
        
        cell.backgroundColor = UIColor.red
        
        
        let letter = letters[indexPath.row]
        
        for view in cell.subviews{
            if let label = view as? UILabel{
                
                
                if letter.isSet {
                    label.text = letter.letter
                    label.backgroundColor = UIColor.magenta
                }else{
                    label.text = getLetter()
                    label.backgroundColor = UIColor.yellow
                }
            }
        }
        return cell
    }
    
    func getLetter()->String{
            let letters = Array("abcdefghijklmnopqrstuvwxyz")
            return String(letters[Int(arc4random_uniform(UInt32(26)))])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width:CGFloat = collectionView.contentSize.width / CGFloat(level.grid)
        
        return CGSize(width: width, height: width)
    }
    
    
}
