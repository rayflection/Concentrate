//
//  ViewController.swift
//  Concentration
//
//  Created by Mike Yost on 12/8/17.
//  Copyright © 2017 Yost. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreKeeper = ScoreKeeper()
        newGameTapped()
    }
    private var scoreKeeper:ScoreKeeper!

    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    var numberOfPairsOfCards: Int {
        return ( cardButtons.count + 1 ) / 2
    }
    private let themeFactory = ThemeFactory()
    private var theme :Theme! = nil
    private var emojiChoices = String()

    @IBOutlet private weak var doneLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var bestScore: UILabel!
    @IBOutlet private weak var elapsed: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            checkForGameOver()
        } else {
            print ("Card not found")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle( emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) :  theme.cardBackgroundColor
            }
        }
        renderScore()
    }

    private func renderScore() {
        elapsed.text = "Time: \(Int(game.getElapsedTime()))"
        let score = scoreKeeper.saveScore(score: game.getScore(), elapsedTime: Int(game.getElapsedTime()))

        
        let attributes : [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "\(game.flipCount) Flips", attributes: attributes)
        flipCountLabel.attributedText = attributedString
        let attributedScore = NSAttributedString(string:  "Score=\(score)",
            attributes: attributes)
        scoreLabel.attributedText = attributedScore
    }

    private func checkForGameOver() {
        if game.isGameOver()  {
            doneLabel.isHidden = false;
            scoreKeeper.saveFinalScore(score: game.getScore(), elapsedTime: Int(game.getElapsedTime()))
            renderBestScore()
            renderScore()
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                button.setTitle( emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        } else {
            doneLabel.isHidden = true;
        }
    }
    private func renderBestScore() {
        bestScore.text = "Best: \(scoreKeeper.getBestScore())"
    }
    private func applyTheme() {
        theme = themeFactory.getNextTheme()
        emojiChoices = theme!.emojis
        self.view.backgroundColor = theme.viewBackgroundColor
    }
    
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil , emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }

    @IBAction private func newGameTapped() {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count+1) / 2)
        applyTheme()
        updateViewFromModel()
        doneLabel.isHidden = true;
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return  Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}


