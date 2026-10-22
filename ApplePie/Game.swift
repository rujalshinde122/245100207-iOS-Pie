//
//  Game.swift
//  ApplePie
//

import Foundation

struct Game {
    var word: String
    var incorrectMovesRemaining: Int
    var guessedLetters: [Character]
    var currentPlayer: Int = 1
    
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
        guessedLetters.append(letter)
        if !word.contains(letter) {
            incorrectMovesRemaining -= 1
            // Switch turn to the other player on incorrect guess
            currentPlayer = (currentPlayer == 1) ? 2 : 1
        }
    }
}
