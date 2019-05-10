//
//  SelectionTableViewController.swift
//  Word Search
//
//  Created by 中尾 佳代 on 2019/05/10.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var levels = [Level]()
    var selectedIndexPath = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
            let url = Bundle.main.url(forResource: "Levels", withExtension: "json")
            if let url = url{
                let data = try! Data(contentsOf: url)
                let decoder = JSONDecoder()
                do{
                    levels = try decoder.decode([Level].self, from: data)
                }catch{
                    print("error")
                }
            }
            self.tableView.reloadData()
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goGame"{
            let gameVC = segue.destination as! GameViewController
            gameVC.level = levels[selectedIndexPath]
        }
    }
    
    
}

extension SelectionViewController: UITableViewDataSource, UITableViewDelegate{
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell", for: indexPath)
     
        let level = levels[indexPath.row]
        cell.textLabel?.text = "Level \(level.level)"
        cell.imageView?.image = UIImage(named: "Eket Mask.gif")
        
     return cell
        
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        performSegue(withIdentifier: "goGame", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
}
