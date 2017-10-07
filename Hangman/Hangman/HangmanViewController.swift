//
//  HangmanViewController.swift
//  Hangman
//
//  Created by Neha Kompella on 10/6/17.
//  Copyright © 2017 iOS DeCal. All rights reserved.
//
import UIKit
import Foundation

class HangmanViewController: UIViewController, UITextFieldDelegate {
    
    var incorrect = [String]()
    
    var num_incorrect = 1
    
    var hangmanPhrase : String?
    var hangmanPhraseArray : [Character]?
    var phraseLen : Int?
    
    var correctGuesses : [Character]?
    var boothNaath : [Bool]?
    
    //MARK: Properties
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var guessField: UILabel!
    @IBOutlet weak var incorrectGuesses: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    //MARK: UITextFieldDelegate
    
    
    //MARK: Actions
    
    @IBAction func submitAction(_ sender: Any) {
        let guess = inputTextField.text!.uppercased()
        print(incorrect)
        print(hangmanPhraseArray)
        if (!correctGuesses!.contains(guess.first!) || !incorrect.contains(guess)) {
            if(hangmanPhrase?.contains(guess.first!))! {
                correctGuesses!.append(guess.first!)
                if(hangmanPhraseArray!.contains(guess.first!)) {
                    for index in 0...phraseLen!-1 {
                        if guess == String(hangmanPhraseArray![index]) {
                            boothNaath![index] = true
                        }
                    }
                }
                
                if (winning()) {
                    let end_game = UIAlertController(title: "You won!", message: "You beat the game. Play again?", preferredStyle: .alert)
                    let end_action = UIAlertAction(
                        title: "New game",
                        style: .default) {
                            action in self.new_game()
                    }
                    
                    end_game.addAction(end_action)
                    self.present(end_game, animated: true, completion: nil)
                }
            }
            else {
                incorrect.append(guess)
                incorrectGuesses.text = "Incorrect Guesses: " + incorrect.map { String($0) }
                    .joined(separator: " ")
                num_incorrect += 1
                
                let image_val = "hangman" + String(num_incorrect) + ".gif"
                
                imageField.image = UIImage(named: image_val)
                
                if (num_incorrect == 7) {
                    let end_game = UIAlertController(title: "Game over!", message: "You lost. Try again?", preferredStyle: .alert)
                    let end_action = UIAlertAction(
                        title: "Moving on",
                        style: .default) {
                            action in self.new_game()
                    }
                    
                    end_game.addAction(end_action)
                    self.present(end_game, animated: true, completion: nil)
                }
            }
        }
        inputTextField.text = ""
        changeField()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.delegate = self
        
        let hangmanPhraseMaker = HangmanPhrases()
        
        // Generate a random phrase for the user to guess
        hangmanPhrase = hangmanPhraseMaker.getRandomPhrase()
        
        hangmanPhraseArray = [Character](hangmanPhrase!.characters)
        
        phraseLen = hangmanPhraseArray!.count
        
        boothNaath = [Bool](repeating: false, count: phraseLen!)
        
        for index in 0...phraseLen!-1 {
            if (String(hangmanPhraseArray![index]) == " ") {
                boothNaath![index] = true
                print("true")
            }
        }
        
        correctGuesses = [Character]()
        
        changeField()
        
        let image_val = "hangman" + String(num_incorrect) + ".gif"
        
        imageField.image = UIImage(named: image_val)
    }
    
    func changeField() {
        guessField.text = ""
        for index in 0...phraseLen!-1 {
            if boothNaath![index] {
                guessField.text = guessField.text! + String(hangmanPhraseArray![index]) + " "
            } else {
                guessField.text = guessField.text! + "- "
            }
        }
    }
    
    func winning() -> Bool {
        var item = true
        for val in boothNaath! {
            if (!val) {
                item = false
            }
        }
        return item
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = inputTextField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 1
    }
    
    func new_game() {
        let hangmanPhraseMaker = HangmanPhrases()
        
        // Generate a random phrase for the user to guess
        hangmanPhrase = hangmanPhraseMaker.getRandomPhrase()
        
        hangmanPhraseArray = [Character](hangmanPhrase!.characters)
        
        phraseLen = hangmanPhraseArray!.count
        
        boothNaath = [Bool](repeating: false, count: phraseLen!)
        
        for index in 0...phraseLen!-1 {
            if (String(hangmanPhraseArray![index]) == " ") {
                boothNaath![index] = true
                print("true")
            }
        }
        
        incorrect = [String]()
        
        correctGuesses = [Character]()
        
        num_incorrect = 1
        
        let image_val = "hangman" + String(num_incorrect) + ".gif"
        
        imageField.image = UIImage(named: image_val)
        
        inputTextField.text = ""
        incorrectGuesses.text = "Incorrect Guesses: "
        
        self.changeField()
    }
    
    
}
