//
//  ViewController.swift
//  Word Search
//
//  Created by 中尾 佳代 on 2019/05/10.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    struct Grid{
        static var amout = 0
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variable
    var level: Level!
    var screenSize = CGRect()
    var letters: [Letter] = []
    var letterAmount = 0
    var selectedIndexes:[IndexPath] = []
    var timer: Timer!
    var numberOfWords = 0
    
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
            case .upLeft: return -Grid.amout - 1
            case .up: return -Grid.amout
            case .upRight: return -Grid.amout + 1
            case .left: return -1
            case .right: return 1
            case .bottomLeft: return Grid.amout - 1
            case .bottom: return Grid.amout
            case .bottomRight: return Grid.amout + 1
            }
        }
        
        var direction: Int {
            return intValue
        }
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Level " + level.level
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)]
        
        letterAmount = level.grid * level.grid
        Grid.amout = level.grid
        
        for num in 0...letterAmount-1{
            let word = Letter(wordId: num, isSet: false, letter:"")
            letters.append(word)
        }
        
        screenSize = UIScreen.main.bounds
        collectionView.contentSize = CGSize(width: screenSize.size.width, height: screenSize.size.height)
        
        startTimer()
        setWords()
        
        panGesture.addTarget(self, action: #selector(didPanToSelectCells))
        collectionView.addGestureRecognizer(panGesture)
        
        collectionView.allowsMultipleSelection = true

    }

    
    //MARK: - Timer Methods
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1 , target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    @objc func runTimedCode() {
        
        if level.time > 0{
            
            level.time -= 1
            timeLabel.text = timeFormatted(level.time)

        }else {
            timeLabel.text = timeFormatted(0)
            
            timer.invalidate()
            timer = nil
        
            showAlart(title: "Time is UP", message: "You found \(level.words.count-numberOfWords) word(s)")
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = totalSeconds / 60 % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }


    //MARK: - Set words in grid
    func setWords(){
        
        for word in level.words{
            
            setWordLabel(word: word)
            numberOfWords += 1
            
            var array:[Letter] = []
            let characters = Array(word)
            
            var keep = true
            
            while keep {
                var i = 0
                
                var startNum = Int.random(in: 0 ..< letterAmount)
                if startNum < 0{
                    startNum = startNum * -1
                }
                
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
        case 0: num = Directions.upLeft(Grid.amout).direction
        case 1: num = Directions.up(Grid.amout).direction
        case 2: num = Directions.upRight(Grid.amout).direction
        case 3: num = Directions.left(Grid.amout).direction
        case 4: num = Directions.right(Grid.amout).direction
        case 5: num = Directions.bottomLeft(Grid.amout).direction
        case 6: num = Directions.bottom(Grid.amout).direction
        case 7: num = Directions.bottomRight(Grid.amout).direction
        default: num = 1
        }
        return num
    }
    
    
    func checkDirection(direction:Int, remind:Int)->Bool{
        
        switch direction {
            
        case Directions.upLeft(Grid.amout).direction,
             Directions.left(Grid.amout).direction,
             Directions.bottomLeft(Grid.amout).direction:
             if remind == level.grid-1 {return true}
            
        case Directions.right(Grid.amout).direction,
             Directions.bottomRight(Grid.amout).direction,
             Directions.upRight(Grid.amout).direction:
             if remind == 0 {return true}
            
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
    
    
    //MARK: - Display words for search
    func setWordLabel(word:String){
        
        let label = UILabel()
        label.text = word
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        stackView.addArrangedSubview(label)
    }
    
    
    //MARK: - UIAlert
    func showAlart(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
    //MARK: -  UIPanGestureRecognizer
    @objc func didPanToSelectCells(panGesture: UIPanGestureRecognizer)->Void{
        
        var location: CGPoint
        let cellLocation: CGPoint
        var indexPath: IndexPath = IndexPath(item: 0, section: 0)
        
        if (panGesture.state == UIGestureRecognizer.State.began){
            location = panGesture.location(in: collectionView)
            
            indexPath = collectionView.indexPathForItem(at: location) ?? IndexPath(item: 0, section: 0)
            
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.red
            
            selectedIndexes.append(indexPath)
            
        }else if (panGesture.state == UIGestureRecognizer.State.changed){
            location = panGesture.location(in: collectionView)
            
            indexPath = collectionView.indexPathForItem(at: location) ?? IndexPath(item: 0, section: 0)
            
            if !selectedIndexes.contains(indexPath){
                let cell = collectionView.cellForItem(at: indexPath)
                cellLocation = panGesture.location(in: cell)
                for view in cell!.subviews{
                    if let label = view as? UILabel {
                        //                        print("celllocation: \(cellLocation)")
                        //                        print("labelFrame: \(label.frame)")
                        if label.frame.contains(cellLocation) {
                            cell?.backgroundColor = UIColor.red
                        }
                    }
                }
                selectedIndexes.append(indexPath)
                cell?.backgroundColor = UIColor.red
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            }
            
        }else if (panGesture.state == UIGestureRecognizer.State.ended){
            var selectedWord = ""
            for indexPath in selectedIndexes{
                let letter = letters[indexPath.row]
                selectedWord = selectedWord + letter.letter
            }
            if level.words.contains(selectedWord){
                for view in stackView.arrangedSubviews{
                    if let lable = view as? UILabel {
                        if lable.text == selectedWord{
                            lable.textColor = UIColor.red
                            break
                        }
                    }
                }
                numberOfWords -= 1
                if numberOfWords == 0 {
                    showAlart(title: "Congratulations!", message: "You found all the words")
                    timer.invalidate()
                }
                selectedIndexes = []
            }else{
                for indexPath in selectedIndexes{
                    let cell = collectionView.cellForItem(at: indexPath)
                    cell?.backgroundColor = UIColor.yellow
                }
                selectedIndexes = []
            }
        }
    }

    
}


//MARK: - UICollectionView delegate, dataSource, delegateFlowLayout
extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letterAmount
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath)
        
        
        let letter = letters[indexPath.row]
        
        for view in cell.subviews{
            if let label = view as? UILabel{
                
             cell.backgroundColor = UIColor.yellow
                
                if letter.isSet {
                    label.text = letter.letter
                }else{
                    label.text = getLetter()
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
