//
//  ViewController.swift
//  ApplePie
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var player1TreeImageView: UIImageView!
    @IBOutlet var player2TreeImageView: UIImageView!
    @IBOutlet var player1Label: UILabel!
    @IBOutlet var player2Label: UILabel!
    @IBOutlet var turnLabel: UILabel!
    @IBOutlet var correctWordLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var letterButtons: [UIButton]!
    
    var listOfWords = ["buccaneer", "swift", "glorious", "incandescent", "bug", "program"]
    let incorrectMovesAllowed = 7
    
    var player1Wins = 0 {
        didSet {
            newRound()
        }
    }
    
    var player2Wins = 0 {
        didSet {
            newRound()
        }
    }
    
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }
    
    var currentGame: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()
    }
    
    func newRound() {
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            // Player 1 always starts first in every round
            currentGame = Game(
                word: newWord,
                player1IncorrectMovesRemaining: incorrectMovesAllowed,
                player2IncorrectMovesRemaining: incorrectMovesAllowed,
                guessedLetters: [],
                currentPlayer: 1,
                lastGuessingPlayer: 1
            )
            enableLetterButtons(true)
            updateUI()
        } else {
            enableLetterButtons(false)
            turnLabel.text = "Game Over"
            player1TreeImageView.alpha = 1.0
            player2TreeImageView.alpha = 1.0
            player1Label.alpha = 1.0
            player2Label.alpha = 1.0
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
        
        // Indicate whose turn it is or if a player is out of moves
        if currentGame.player1IncorrectMovesRemaining == 0 && currentGame.player2IncorrectMovesRemaining > 0 {
            turnLabel.text = "Player 1 out! Player 2's Turn"
        } else if currentGame.player2IncorrectMovesRemaining == 0 && currentGame.player1IncorrectMovesRemaining > 0 {
            turnLabel.text = "Player 2 out! Player 1's Turn"
        } else {
            turnLabel.text = "\(currentGame.currentPlayerName)'s Turn"
        }
        
        scoreLabel.text = "Player 1: \(player1Wins) Wins | Player 2: \(player2Wins) Wins | Losses: \(totalLosses)"
        
        // Update both trees with their individual remaining moves
        player1TreeImageView.image = UIImage(named: "Tree \(currentGame.player1IncorrectMovesRemaining)")
        player2TreeImageView.image = UIImage(named: "Tree \(currentGame.player2IncorrectMovesRemaining)")
        
        // Highlight the active player's tree and label
        if currentGame.currentPlayer == 1 {
            player1TreeImageView.alpha = 1.0
            player2TreeImageView.alpha = 0.5
            player1Label.alpha = 1.0
            player2Label.alpha = 0.5
        } else {
            player1TreeImageView.alpha = 0.5
            player2TreeImageView.alpha = 1.0
            player1Label.alpha = 0.5
            player2Label.alpha = 1.0
        }
    }

    @IBAction func letterButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.configuration!.title!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    func updateGameState() {
        if currentGame.word == currentGame.formattedWord {
            if currentGame.lastGuessingPlayer == 1 {
                player1Wins += 1
            } else {
                player2Wins += 1
            }
        } else if currentGame.player1IncorrectMovesRemaining == 0 && currentGame.player2IncorrectMovesRemaining == 0 {
            totalLosses += 1
        } else {
            updateUI()
        }
    }
}
