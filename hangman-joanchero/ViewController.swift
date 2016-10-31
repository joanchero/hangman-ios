//
//  ViewController.swift
//  hangman-joanchero
//
//  Created by Joan sirma on 10/28/16.
//  Copyright © 2016 Joan sirma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var word: UILabel!
    @IBOutlet var checkButton: UILabel!
    @IBOutlet var currentWord: UILabel!
    @IBOutlet var lifeLabel: UILabel!
    @IBOutlet var gameStatusLabel: UILabel!
    @IBOutlet var hintLabel: UILabel!
    
    var wordArray = [Character]()
    var dashStringArray = [Character]()
    var dashString: String = ""
    var hangmanWord: String = ""
    var counter = 10
    var matched = false
    var charLeft = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load words from text file
        let wordsArray = linesFromResource(fileName: "wordsList.txt")
        let hintsArray = linesFromResource(fileName: "hintsList.txt")
        
        let wordsArrayLength = wordsArray.count
        
      //randomly select words from list
        let randomNumber: Int = Int(arc4random_uniform(UInt32(wordsArrayLength)))
        
        // get words from selcted array
        let randomWord = wordsArray[randomNumber]
        let randomHint = hintsArray[randomNumber]
        
        hintLabel.text = "Hint: ".appending(randomHint)
        hangmanWord = randomWord
        
        charLeft = hangmanWord.characters.count
        
        // inser wordArray into the given array
        wordArray = Array(hangmanWord.characters)
        
      
        dashStringArray = Array(dashString.characters)
        
        // Display dashString according to the hmWord
        displayWord()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func linesFromResource(fileName: String) -> [String] {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil)
            else {
            fatalError("Resource file for \(fileName) not found.")
        }
        do {
            let content = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n")
        } catch let error {
            fatalError("Unable to load\(path): \(error).")
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        // Set buttonLetter to the current Letter
        let buttonLetter: String = sender.currentTitle!
        
        checkButton.text = "Wrong Latters: ".appending(buttonLetter)
        
        for (index, _) in wordArray.enumerated()
        {
            // Check if char at index is equal to buttonLetter, if it is, replace hmWord[index] with *
            let hmWordChar = String(wordArray[index])
            if (buttonLetter == hmWordChar)
            {
                wordArray[index] = "*"
                charLeft -= 1
                matched = true;
            }
        }
        updateLife()
        checkGameStatus()
        displayWord()
    }
    
    func displayWord() {
        var newDashString = ""
        let startIndex = hangmanWord.startIndex
        let endIndex = hangmanWord.endIndex
        
        for index in 0...hangmanWord.characters.count - 1 {
            if(wordArray[index] == " ") {
                newDashString += "   ";
            }
            else if (String(wordArray[index]) == "*") {
                newDashString += String(hangmanWord[hangmanWord.index(startIndex, offsetBy: index, limitedBy: endIndex)!])
            }
            else {
                newDashString += "_ ";
            }
        }
        dashString = newDashString
        word.text = dashString;
    }
    
    func updateLife() {
        if (matched == true) {
            matched = false
        }
        else
        {
            counter -= 1
            lifeLabel.text = "Life: ".appending(String(counter))
        }
    }
    
    func checkGameStatus() {
        if (charLeft == 0)
        {
            gameStatusLabel.text = "YOU WIN!!!!!"
        }
        if (counter == 0)
        {
            gameStatusLabel.text = "YOU LOSE!"
        }
        
    }
}

