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
                var startNum = Int(arc4random_uniform(UInt32(letterAmount-1)))
                var direction = getDirection()
                
                if characters.count >= 10 {
                    let remind = startNum % 10
                    startNum = startNum + (10 - remind)
                    if startNum >= 100 {
                        startNum = startNum - 90
                    }
                    direction = 1
                }
                
                for char in characters{
                    var letter:Letter
                    if i != 0 {
                        let remaind = (startNum + direction*i) % 10
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
        
        var num = Int(arc4random_uniform(UInt32(8)))
        
        switch num {
        case 0: num =  -11
        case 1: num = -10
        case 2: num = -9
        case 3: num = -1
        case 4: num = 1
        case 5: num = 9
        case 6: num = 10
        case 7: num = 11
        default: num = 1
        }
        
        return num
    }
    
    func checkDirection(direction:Int, remind:Int)->Bool{
        
        switch direction {
        case -1, -11, 9: if remind == 9 {return true}
        case 1, 11, -9: if remind == 0 {return true}
        
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
