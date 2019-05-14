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
        static var num = 0
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
    var timer: Timer!
    var foundIndexes:[IndexPath] = []
    var selectedIndexes:[IndexPath] = []
    
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
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Level " + level.level
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)]
        
        collectionView.backgroundColor = UIColor.GameColor.GridYellow
        
        letterAmount = level.grid * level.grid
        Grid.num = level.grid

        
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
        
            showAlart(title: "Time is UP", message: "\(level.words.count) word(s) left")
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
            
            var array:[Letter] = []
            let characters = Array(word)
            var keep = true
            
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
        var index = 0
        for var letter in letters{
            if !letter.isSet {
                letter.letter = getLetter()
                letters[index] = letter
            }
            index += 1
        }
        
    }
    
    
    func getDirection()-> Int{
        
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
    
    
    func checkDirection(direction:Int, remind:Int)->Bool{
        
        switch direction {
            
        case Directions.upLeft(Grid.num).direction,
             Directions.left(Grid.num).direction,
             Directions.bottomLeft(Grid.num).direction:
             if remind == level.grid-1 {return true}
            
        case Directions.right(Grid.num).direction,
             Directions.bottomRight(Grid.num).direction,
             Directions.upRight(Grid.num).direction:
             if remind == 0 {return true}
            
        default: return false
        }
        return false
    }
    
    
    func  resetLetters(array:[Letter]){
        
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
        var cellLocation: CGPoint
        var indexPath: IndexPath = IndexPath(item: 0, section: 0)
        
        if (panGesture.state == UIGestureRecognizer.State.began){
            location = panGesture.location(in: collectionView)
            
            indexPath = collectionView.indexPathForItem(at: location) ?? IndexPath(item: 0, section: 0)
            
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.GameColor.SelectGreen
            
            selectedIndexes.append(indexPath)
            
        }else if (panGesture.state == UIGestureRecognizer.State.changed){
            location = panGesture.location(in: collectionView)
            
            indexPath = collectionView.indexPathForItem(at: location) ?? IndexPath(item: 0, section: 0)
            
            if !selectedIndexes.contains(indexPath){
                let cell = collectionView.cellForItem(at: indexPath)
                cellLocation = panGesture.location(in: cell)
                for view in cell!.subviews{
                    if let label = view as? UILabel {
                        
                        if label.frame.contains(cellLocation) {
                            cell?.backgroundColor = UIColor.GameColor.SelectGreen
                            selectedIndexes.append(indexPath)
                        }
                    }
                }
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            }
            
        }else if (panGesture.state == UIGestureRecognizer.State.ended){
            var selectedWord = ""
            for indexPath in selectedIndexes{
                let letter = letters[indexPath.row]
                selectedWord = selectedWord + letter.letter
            }
            
            if level.words.contains(selectedWord){
                let index = level.words.firstIndex(of: selectedWord)
                level.words.remove(at: index!)
                

                for view in stackView.arrangedSubviews{
                    if let label = view as? UILabel {
                        if label.text == selectedWord{
                            label.textColor = UIColor.GameColor.ChosenRed
                            label.font = UIFont.systemFont(ofSize: label.font.pointSize, weight: .thin)
                            break
                        }
                    }
                }
                for indexPath in selectedIndexes{
                    let cell = collectionView.cellForItem(at: indexPath)
                    UIView.animate(withDuration: 1, animations: { () -> Void in
                        cell?.backgroundColor = UIColor.GameColor.ChosenRed
                    })
                    foundIndexes.append(indexPath)
                }
 
                if level.words.count == 0 {
                    showAlart(title: "Congratulations!", message: "You've found all the words")
                    timer.invalidate()
                }
                selectedIndexes = []
                
            }else{
                for indexPath in selectedIndexes{
                        let cell = collectionView.cellForItem(at: indexPath)
                     if !foundIndexes.contains(indexPath){
                        UIView.animate(withDuration: 1, animations: { () -> Void in
                            cell?.backgroundColor = UIColor.GameColor.GridYellow
                        })
                     }else{
                        UIView.animate(withDuration: 1, animations: { () -> Void in
                            cell?.backgroundColor = UIColor.GameColor.ChosenRed
                        })
                    }
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
                cell.backgroundColor = UIColor.clear//UIColor.GameColor.GridYellow
                label.text = letter.letter
                if let customCell = cell as? CustomCollectionViewCell{
                    customCell.setupSubview(label: label, sender:customCell)
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
        
        print("cell size \(width)")

        return CGSize(width: width, height: width)
    }
    
}
