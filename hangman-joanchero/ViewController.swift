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
    @IBOutlet var clickedButton: UILabel!
    @IBOutlet var curWord: UILabel!
    @IBOutlet var lifeLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var hintLabel: UILabel!
    
    var WordArray = [Character]()
    var dashStringArray = [Character]()
    var dashString: String = ""
    var hangmanWord: String = ""
    var counter = 10
    var matched = false
    var charLeft = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Read in the words.txt and hints.txt
        let wordsArray = linesFromResource(fileName: "wordlist.txt")
        let hintsArray = linesFromResource(fileName: "hintslist.txt")
        
        let wordsArrayLength = wordsArray.count
        
        // Create a random number to pick from the list of words
        let randomNumber: Int = Int(arc4random_uniform(UInt32(wordsArrayLength)))
        
        // Getting the random word from the array
        let randomWord = wordsArray[randomNumber]
        let randomHint = hintsArray[randomNumber]
        
        hintLabel.text = "Hint: ".appending(randomHint)
        hangmanWord = randomWord
        
        charLeft = hangmanWord.characters.count
        
        // Put hmWord into an array of characters
        WordArray = Array(hangmanWord.characters)
        
        // Put dashString into an array of characters
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
                fatalError("The file \(fileName) not found.")
        }
        do {
            let content = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n")
        } catch let error {
            fatalError("Could not load \(path): \(error).")
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        // Set buttonLetter to the current Letter
        let buttonLetter: String = sender.currentTitle!
        
        clickedButton.text = "Button Selected: ".appending(buttonLetter)
        
        for (index, _) in WordArray.enumerated()
        {
            // Check if char at index is equal to buttonLetter, if it is, replace hmWord[index] with *
            let hmWordChar = String(WordArray[index])
            if (buttonLetter == hmWordChar)
            {
                WordArray[index] = "*"
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
            if(WordArray[index] == " ") {
                newDashString += "   ";
            }
            else if (String(WordArray[index]) == "*") {
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
            statusLabel.text = "CONGRATS!!! YOU WIN!!"
        }
        if (counter == 0)
        {
            statusLabel.text = "GAME OVER"
        }
        
    }
}

