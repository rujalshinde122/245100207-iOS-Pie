//
//  Game.swift
//  ApplePie
//

import Foundation

struct Game {
    var word: String
    var player1IncorrectMovesRemaining: Int
    var player2IncorrectMovesRemaining: Int
    var guessedLetters: [Character]
    var currentPlayer: Int = 1
    var lastGuessingPlayer: Int = 1
    
    var currentPlayerName: String {
        return "Player \(currentPlayer)"
    }
    
    var formattedWord: String {
        var guessedWord = ""
        for letter in word {
            if guessedLetters.contains(letter) {
                guessedWord += "\(letter)"
            } else {
                guessedWord += "_"
            }
        }
        return guessedWord
    }
    
    mutating func playerGuessed(letter: Character) {
        lastGuessingPlayer = currentPlayer
        guessedLetters.append(letter)
        
        let isCorrect = word.contains(letter)
        if !isCorrect {
            if currentPlayer == 1 {
                player1IncorrectMovesRemaining -= 1
            } else {
                player2IncorrectMovesRemaining -= 1
            }
        }
        
        // If word is completely solved, keep currentPlayer as the winner
        if word == formattedWord {
            return
        }
        
        // Turn-by-turn alternation: switch to the other player if they have moves left
        switchTurn()
    }
    
    mutating func switchTurn() {
        let otherPlayer = (currentPlayer == 1) ? 2 : 1
        let otherPlayerHasMoves = (otherPlayer == 1) ? (player1IncorrectMovesRemaining > 0) : (player2IncorrectMovesRemaining > 0)
        let currentPlayerHasMoves = (currentPlayer == 1) ? (player1IncorrectMovesRemaining > 0) : (player2IncorrectMovesRemaining > 0)
        
        if otherPlayerHasMoves {
            currentPlayer = otherPlayer
        } else if currentPlayerHasMoves {
            // Keep currentPlayer since other player has no moves left
        }
    }
}
