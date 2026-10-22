//
//  ViewController.swift
//  ApplePie
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var treeImageView: UIImageView!
    @IBOutlet var turnLabel: UILabel!
    @IBOutlet var correctWordLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var letterButtons: [UIButton]!
    
    var listOfWords = ["buccaneer", "swift", "glorious", "incandescent", "bug", "program"]
    let incorrectMovesAllowed = 7
    
    var activePlayer = 1
    
    var player1Wins = 0 {
        didSet {
            nextTurn()
        }
    }
    
    var player2Wins = 0 {
        didSet {
            nextTurn()
        }
    }
    
    var totalLosses = 0 {
        didSet {
            nextTurn()
        }
    }
    
    var currentGame: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()
    }
    
    func nextTurn() {
        // Switch to the other player for the next round
        activePlayer = (activePlayer == 1) ? 2 : 1
        newRound()
    }
    
    func newRound() {
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            currentGame = Game(
                word: newWord,
                incorrectMovesRemaining: incorrectMovesAllowed,
                guessedLetters: [],
                player: activePlayer
            )
            enableLetterButtons(true)
            updateUI()
        } else {
            enableLetterButtons(false)
            turnLabel.text = "Game Over"
        }
    }
    
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        
        turnLabel.text = "\(currentGame.playerName)'s Turn"
        scoreLabel.text = "Player 1: \(player1Wins) Wins | Player 2: \(player2Wins) Wins | Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
    }

    @IBAction func letterButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.configuration!.title!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            // Active player lost this round
            totalLosses += 1
        } else if currentGame.word == currentGame.formattedWord {
            // Active player won this round
            if currentGame.player == 1 {
                player1Wins += 1
            } else {
                player2Wins += 1
            }
        } else {
            updateUI()
        }
    }
}
