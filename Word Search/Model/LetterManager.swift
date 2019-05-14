//
//  LetterManager.swift
//  Word Search
//
//  Created by 中尾 佳代 on 2019/05/14.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import Foundation

class LetterManager{
    
    struct Grid{
        static var num = 0
        static var letters:[Letter] = []
    }
    
    //MARK: - Directions
    enum Directions {
        case upLeft(Int)
        case up(Int)
        case upRight(Int)
        case left(Int)
        case right(Int)
        case bottomLeft(Int)
        case bottom(Int)
        case bottomRight(Int)
        
        var intValue: Int{
            switch self {
            case .upLeft: return -Grid.num - 1
            case .up: return -Grid.num
            case .upRight: return -Grid.num + 1
            case .left: return -1
            case .right: return 1
            case .bottomLeft: return Grid.num - 1
            case .bottom: return Grid.num
            case .bottomRight: return Grid.num + 1
            }
        }
        
        var direction: Int {
            return intValue
        }
    }
    
    
    //MARK: - Set words in grid
    class func setWords(level: Level) -> [Letter]{

        
        for num in 0..<level.grid * level.grid{
            let letter = Letter(wordId: num, isSet: false, letter:"")
            Grid.letters.append(letter)
        }
        
        Grid.num = level.grid

        for word in level.words{

            var array:[Letter] = []
            let characters = Array(word)
            var keep = true
            let letterAmount = Grid.num * Grid.num
            
            while keep {
                var i = 0
                var startNum = Int.random(in: 0 ..< letterAmount)
                var direction = getDirection()
                
                if characters.count >= Grid.num {
                    let remind = startNum % 10
                    startNum = startNum + (Grid.num - remind)
                    
                    if startNum >= letterAmount {
                        startNum = startNum - Grid.num
                    }
                    direction = Directions.right(Grid.num).direction
                }
                
                for char in characters{
                    var letter:Letter
                    if i != 0 {
                        let remaind = (startNum + direction*i) % Grid.num
                        let checked = checkDirection(direction: direction, remind: remaind)
                        
                        if startNum + direction*i < 0 || startNum + direction*i >= letterAmount || checked {
                            resetLetters(array: array)
                            array = []
                            break
                        }else {
                            letter = Grid.letters[startNum+direction*i]
                        }
                    }else {
                        letter = Grid.letters[startNum]
                    }
                    
                    if !letter.isSet{
                        letter.isSet = true
                        letter.letter = String(char)
                        Grid.letters[letter.wordId] = letter
                        
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
        var index = 0
        for var letter in Grid.letters{
            if !letter.isSet {
                letter.letter = getLetter()
                Grid.letters[index] = letter
            }
            index += 1
        }
        
        return Grid.letters
    }
    
    static func getDirection()-> Int{
        
        var num = Int.random(in: 0 ... 7)
        
        switch num {
        case 0: num = Directions.upLeft(Grid.num).direction
        case 1: num = Directions.up(Grid.num).direction
        case 2: num = Directions.upRight(Grid.num).direction
        case 3: num = Directions.left(Grid.num).direction
        case 4: num = Directions.right(Grid.num).direction
        case 5: num = Directions.bottomLeft(Grid.num).direction
        case 6: num = Directions.bottom(Grid.num).direction
        case 7: num = Directions.bottomRight(Grid.num).direction
        default: num = 1
        }
        return num
    }
    
    
    static func checkDirection(direction:Int, remind:Int)->Bool{
        
        switch direction {
            
        case Directions.upLeft(Grid.num).direction,
             Directions.left(Grid.num).direction,
             Directions.bottomLeft(Grid.num).direction:
            if remind == Grid.num-1 {return true}
            
        case Directions.right(Grid.num).direction,
             Directions.bottomRight(Grid.num).direction,
             Directions.upRight(Grid.num).direction:
            if remind == 0 {return true}
            
        default: return false
        }
        return false
    }
    
    
    static func  resetLetters(array:[Letter]){
        
        for var letter in array{
            letter.isSet = false
            letter.letter = ""
            Grid.letters[letter.wordId] = letter
        }
    }
    
    static func getLetter()->String{
        
        let letters = Array("abcdefghijklmnopqrstuvwxyz")
        return String(letters[Int(arc4random_uniform(UInt32(26)))])
    }
    
    class func resetData(){
        Grid.letters = []
    }
    
}
