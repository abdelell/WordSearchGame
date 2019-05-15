//
//  ViewController.swift
//  WordSearch
//  Created by macbook on 5/11/19.
//  Copyright © 2019 Abdel. All rights reserved.
//

// NOTE: Works best with plus sized iPhones
/*
How the word search is created:
It starts out with a list of 100 0's (since this is a 10x10 grid). The insertWords() function then takes each word that needs to be in the wordsearch and randomly chooses weather the word will be horizontal or vertical, and chooses the next function accordingly. After all the words that can fit in the grid have been inserted, the fillRestOfGrid() function is called to fill the rest of the grid with random letters.
 How the selecting words works:
When a player starts swiping in the collection view the UIPanGesture gets the location of the swipe and selects the corresponding cell in the collection view. The first two cells that are selected act as a base to determine whether the player is swiping horizontally or vertically. After the player selects the set of letters then the cells remain selected if the letters matched a word, otherwise they are deselected.
*/
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var gridCount = 10
    
    // for collectionView
    let reuseIdentifier = "cell"
    
    var wordsFound = [String]()
    var wordsLeft = [String]()
    
    // You can put as many words as you want, if a word doesn't fit it won't be inserted in the grid
    let wordList = ["swift", "kotlin", "objectivec", "variable", "java", "mobile", "soccer", "goat", "ronaldo"]
    var items = ["0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"]
    // orientation of selection
    var orientation = "ver"
    var orientationIndexPath = 0
    
    var canWordBeVertical = true
    var canWordBeHorizontal = true
    
    //For selecting words
    var listOfLetters = [Int]()
    var listOfIndexes = [IndexPath]()
    
    //used to check how many cells are selected
    var numberOfCells = 0
    var firstIndexPath = [Int]()
    var secondIndexPath = [Int]()

    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var wordsFoundLabel: UILabel!
    @IBOutlet weak var wordsLeftLabel: UILabel!
    @IBOutlet weak var CollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        //Collection View for grid
        self.CollectionView.dataSource = self
        self.CollectionView.delegate = self
        self.CollectionView.allowsMultipleSelection = true
        
        //tableView for the wordsLeft list
        self.tableView1.delegate = self
        self.tableView1.dataSource = self
        self.tableView1.separatorColor = UIColor.clear
        self.tableView1.allowsSelection = false
        
        //tableView for the wordsFound list
        self.tableView2.delegate = self
        self.tableView2.dataSource = self
        self.tableView2.separatorColor = UIColor.clear
        self.tableView2.allowsSelection = false
        
        //Gesture to select multiple cells by swiping over them
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        panGesture.delegate = self
        self.CollectionView.addGestureRecognizer(panGesture)
        
        
    }
    
    // for restarting the game
    func loadData(){
        items = ["0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"]
        
        // initializes the wordsleft table to have all the words needed
        wordsLeft = wordList
        
        // Removes all words found, so that the player can start fresh
        wordsFound.removeAll()
        
        //function that inserts words into the grid
        insertWords()
        fillRestOfGrid()
        
        wordsFoundLabel.text = "Words Found: 0"
        wordsLeftLabel.text = "Words Left: \(wordsLeft.count)"
        
        tableView1.reloadData()
        tableView2.reloadData()
        CollectionView.reloadData()
    }
    
    
    func insertWords(){
        for word in wordList {
            //chooses 0 or 1 at random
            let horOrVer = Int(arc4random_uniform(2))
            
            // word will be horizontal
            if horOrVer == 0 {
                horizontalWordCheck(word: word)
            //word will be vertical
            } else {
                verticalWordCheck(word: word)
            }
        }
        
    }
    func horizontalWordCheck(word : String){
        // the max placement the word can be to be able to fit
        let maxStart = gridCount - word.count
        // random row
        var randomRowStart = Int.random(in: 0...(gridCount-1))
        // random column between 0 and the max placement
        var randomColStart = Int.random(in: 0...maxStart)
        
        var validSpace = false
        
        /* This for-loop first checks whether the random row and column will work for the word
         if it doesnt then it does another for loop to check if it can fit anywhere on that row,
         if it cant then it iterates through all the rows and does the same process again. If nothing works then
         it tries to insert the word vertically. If that doesnt work then the word is removed from the list
         */
        for rowNum in 0..<gridCount {
            var rowStart = randomRowStart + rowNum
            for i in 0..<word.count {
                
                if rowStart >= gridCount {
                    rowStart -= gridCount
                }
                if items[rowStart * 10 + randomColStart + i] != "0" {
                    //There is a letter in this space
                    validSpace = false
                    break
                } else {
                    validSpace = true
                }
            }
            if validSpace {
                randomRowStart = rowStart
                break
            } else {
                for i in 0...(maxStart-randomColStart){
                    for n in 0..<word.count { //5
                        if items[rowStart * 10 + i + n] != "0" {
                            //There is a letter in this space
                            validSpace = false
                            break
                        } else {
                            validSpace = true
                        }
                    }
                    if validSpace {
                        randomColStart = i
                        break
                    }
                }
            }
        }
        
        if validSpace {
            for i in 0..<word.count {
                items[randomRowStart * 10 + randomColStart + i] = word[i].capitalized
            }
        } else {
            print("\(word) Can't Fit Horizontally in Grid, all possible solutions tried")
            canWordBeHorizontal = false
            
            if canWordBeVertical {
                verticalWordCheck(word: word)
            } else {
                print("\(word) CAN'T FIT IN GRID")
                //resets variables to default
                canWordBeVertical = true
                canWordBeHorizontal = true
                wordsLeft = wordsLeft.filter{$0 != word.lowercased()}
            }
            
        }
        
        print("\(word): Row = \(randomRowStart) Column = \(randomColStart)")
    }
    
    func verticalWordCheck(word : String){
        let maxStart = gridCount - word.count
        var randomRowStart = Int.random(in: 0...maxStart) //5
        var randomColStart = Int.random(in: 0...(gridCount-1)) //1
        
        var validSpace = false
        
        /* This for-loop first checks whether the random row and column will work for the word
         if it doesnt then it does another for loop to check if it can fit anywhere on that column,
         if it cant then it iterates through all the columns and does the same process again. If nothing works then
         it tries to insert the word horizontally. If that doesnt work then the word is removed from the list
         */
        for colNum in 0..<gridCount {
            var colStart = randomColStart + colNum //5
            for i in 0..<word.count { //5
                
                if colStart >= gridCount {
                    colStart -= gridCount
                }
                if items[colStart + (randomRowStart + i) * 10] != "0" {
                    //There is a letter in this space
                    validSpace = false
                    break
                } else {
                    validSpace = true
                }
            }
            if validSpace {
                randomColStart = colStart
                break
            } else {
                for i in 0...(maxStart-randomRowStart){
                    for n in 0..<word.count { //5
                        if items[colStart + (i+n) * 10] != "0" {
                            //There is a letter in this space
                            validSpace = false
                            break
                        } else {
                            validSpace = true
                        }
                    }
                    if validSpace {
                        randomRowStart = i
                        break
                    }
                }
            }
        }
        if validSpace {
            for i in 0..<word.count {
                items[randomColStart + (randomRowStart + i) * 10] = word[i].capitalized
            }
        } else {
            print("\(word) Can't Fit Vertically in Grid, all possible solutions tried")
            canWordBeVertical = false
            if canWordBeHorizontal {
                horizontalWordCheck(word: word)
            } else {
                print("\(word) CAN'T FIT IN GRID")
                //resets variables to default
                canWordBeVertical = true
                canWordBeHorizontal = true
                wordsLeft = wordsLeft.filter{$0 != word.lowercased()}
            }
            
        }
        
        //        print("\(word): Row = \(randomRowStart) Column = \(randomColStart)")
    }
    
    //Fills the rest of the grid with random upper case letters
    func fillRestOfGrid(){
        for itemNum in 0..<items.count {
            let uppercaseLetters = (65...90).map {String(UnicodeScalar($0))}
            if items[itemNum] == "0"{
                items[itemNum] = uppercaseLetters.randomElement()!
            }
        }
    }
    
    //used to figure out wheather the player will be swiping horizontally or vertically
    //which then doesnt allow them to swipe in any other direction
    func orientationSetter() {
        
        //checks if the rows are the same
        if firstIndexPath[0] == secondIndexPath[0] {
            orientation = "hor"
            orientationIndexPath = firstIndexPath[0]
            print("Orientation is Horizontal")
        
        //checks if the columns are the same
        } else if firstIndexPath[1] == secondIndexPath[1]{
            orientation = "ver"
            orientationIndexPath = firstIndexPath[1]
            print("Orientation is Vertical")
            
        // will mostly likely occur if the player swipes diagonally
        } else {
            print("No orientation Found")
        }
        
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer){
        
        let indexPath = CollectionView.indexPathForItem(at: gesture.location(in: CollectionView))
        numberOfCells += 1

        if let index = indexPath {
            
            if listOfLetters.contains(index[1]) {
                
            } else {
                // appends the letters and indexes if it doesnt already exist in the list
                // because when swiping sometimes the same cell is "tapped" twice
                listOfLetters.append(index[1])
                listOfIndexes.append(index)
            }
            
            //gets row number of the index
            let rowNum = findRowNumber(itemNum: index[1])
            // gets column number of the index
            let colNum = findColumnNumber(itemNum: index[1])
            if numberOfCells == 1 {
                // this is the first chosen cell
                firstIndexPath = [rowNum, colNum]
                CollectionView.selectItem(at: index, animated: true, scrollPosition: UICollectionView.ScrollPosition())
            } else if numberOfCells == 2 {
                // this is the second chosen cell
                secondIndexPath = [rowNum, colNum]
                if firstIndexPath == secondIndexPath {
                    // if its the same cell don't do anything
                    numberOfCells -= 1
                } else {
                    CollectionView.selectItem(at: index, animated: true, scrollPosition: UICollectionView.ScrollPosition())
                    orientationSetter()
                }
                
            }
            
            if orientation == "hor" {
                //checks whether the chosen cell matches the horizontal pattern
                //if it doesn't then it doesnt select the cell
                if rowNum == orientationIndexPath {
                    CollectionView.selectItem(at: index, animated: true, scrollPosition: UICollectionView.ScrollPosition())
                }
            } else if orientation == "ver" {
                //checks whether the chosen cell matches the vertical pattern if it doesnt, then it
                // doesnt select the cell
                if colNum == orientationIndexPath {
                    CollectionView.selectItem(at: index, animated: true, scrollPosition: UICollectionView.ScrollPosition())
                }
            }
            if gesture.state == .ended {
                panEnded()
            }
//            print("Cell Number: \(numberOfCells)")
//            print("Index Row Number: \(index)")
            
        }
        
    }
    
    func findRowNumber(itemNum : Int) -> Int {
        // if its less than 9 that means its in the first row
        if itemNum <= 9 {
            return 0
        } else {
            // the first digit of the item number will be its row becuase it goes up by 10s
            let firstDigit = "\(itemNum)".prefix(1)
            return Int(firstDigit)!
            
        }
    }
    func findColumnNumber(itemNum : Int) -> Int {
        //the last digit will be the column since it is a 10x10 grid
        let secondDigit = "\(itemNum)".suffix(1)
        return Int(secondDigit)!
    }
    
    func panEnded() {
        var word = ""
        for itemNum in listOfLetters.sorted() {
            word += items[itemNum]
        }
        if wordsLeft.contains(word.lowercased()) {
            //removes word from list
            wordsLeft = wordsLeft.filter{$0 != word.lowercased()}
            // adds word to the words found list
            wordsFound.append(word.lowercased())
            tableView1.reloadData()
            tableView2.reloadData()
            wordsFoundLabel.text = "Words Found: \(wordsFound.count)"
            wordsLeftLabel.text = "Words Left: \(wordsLeft.count)"
            print("\(word) FOUND")
            checkIfPlayerWon()
        } else {
            //deselect the cells if they are not one of the word
            deselectAllItems(animated: true)
        }
        
        print("Word: \(word)")

        listOfLetters.removeAll()
        listOfIndexes.removeAll()
        //resets the number of cells selected to 0
        numberOfCells = 0
    }
    
    func deselectAllItems(animated: Bool) {
        for indexPath in listOfIndexes {
            CollectionView.deselectItem(at: indexPath, animated: animated)
        }
    }
    
    func checkIfPlayerWon() {
        if wordsLeft.count == 0 {
            let alert = UIAlertController(title: "YOU WON!", message: "Would You Like to Restart?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { action in
                self.loadData()
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! LetterCollectionViewCell
        
        cell.letterLabel.text = self.items[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return wordsLeft.count
        } else {
            return wordsFound.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // the words left table view
        if tableView == tableView1 {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "tableCell")
            cell.textLabel?.text = wordsLeft[indexPath.row]
            cell.textLabel?.textAlignment = .left
            return cell
        } else { // the words found table view
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "table2Cell")
            cell.textLabel?.text = wordsFound[indexPath.row]
            cell.textLabel?.textAlignment = .right
            return cell
        }
        
    }

    @IBAction func restartButtonAction(_ sender: Any) {
        loadData()
    }
    
}

extension Int {
    var digits: [Int] {
        return String(self).compactMap{ Int(String($0)) }
    }
}

// To get nth letter of string
extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
