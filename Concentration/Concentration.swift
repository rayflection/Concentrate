//
//  Concentration.swift
//  Concentration
//
//  Created by Mike Yost on 12/8/17.
//  Copyright © 2017 Yost. All rights reserved.
//

import Foundation

struct Concentration
{
    private(set) var cards = [Card]()
    private var totalMatches = 0
    private var elapsedTime = 0.0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    private var score=0
    var flipCount=0
    private var startTime = Date()

    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards.")
        if ( cards[index].isFaceUp ) {
            return
        }
        flipCount += 1
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    totalMatches += 2
                    score += 2
                } else {
                    // these two cards were involved in a mismatch
                    if ( cards[index].previouslyShown ) {
                        score -= 1
                    }
                    cards[matchIndex].previouslyShown =  true
                    cards[index].previouslyShown = true
                }
                cards[index].isFaceUp = true
            } else {
                // either no cards or 2 cards are face up
                cards[index].previouslyShown = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    func isGameOver() -> Bool {
        return totalMatches >= cards.count
    }
    
    func getScore() -> Int {
        return score
    }

    func getElapsedTime() -> Double {
        return Date().timeIntervalSince(startTime)
    }
    init(numberOfPairsOfCards:Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init( \(numberOfPairsOfCards)): there must be at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]  // 2 copies appended to the array
        }
        shuffleCards()
        totalMatches = 0
        flipCount = 0
        startTime = Date()
    }
    
    private mutating func shuffleCards() {
        if cards.count > 0 {
            var tempCards = [Card]()
            repeat {
                let randomlySelectedCard = cards.remove(at: cards.count.arc4random)
                tempCards.append(randomlySelectedCard)
            } while cards.count > 0
            cards = tempCards
        }
    }
}
extension Collection {
    var oneAndOnly: Element? {
    return count == 1 ? first : nil
    }
}
