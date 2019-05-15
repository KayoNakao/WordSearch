//
//  ViewController.swift
//  Word Search
//
//  Created by 中尾 佳代 on 2019/05/10.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Variable
    var level: Level!
    var screenSize = CGRect()
    var letters: [Letter] = []
    var timer: Timer!
    var foundIndexes:[IndexPath] = []
    var selectedIndexes:[IndexPath] = []
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Level " + level.level
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .thin)]
        
        collectionView.backgroundColor = UIColor.GameColor.GridYellow
        
        
        startTimer()
        letters = LetterManager.setWords(level: level)
        
        for word in level.words{
            setWordLabel(word: word)
        }
        
        panGesture.addTarget(self, action: #selector(didPanToSelectCells))
        collectionView.addGestureRecognizer(panGesture)
        
    }

    
    //MARK: - Display words for search
    func setWordLabel(word:String){
        
        let label = UILabel()
        label.text = word
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        stackView.addArrangedSubview(label)
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
        
            if level.wordNum - level.words.count == 0 {
                showAlart(title: "Sorry!", message: "You've found 0 word...\nTry again and good luck!")

            }else {
                showAlart(title: "Time is UP", message: "You've found \(level.wordNum - level.words.count) word(s)")
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = totalSeconds / 60 % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    
    
    //MARK: - UIAlert
    func showAlart(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
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
                    showAlart(title: "Congratulations!", message: "You've found all the words!\n(\(level.wordNum) words)")
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
    
    //MARk : - viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        LetterManager.resetData()
        letters = []
    }
}



//MARK: - UICollectionView delegate, dataSource, delegateFlowLayout
extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return level.grid * level.grid
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let width:CGFloat = collectionView.visibleSize.width / CGFloat(level.grid)
        
        return CGSize(width: width, height: width)
    }
    
}
