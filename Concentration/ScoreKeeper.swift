//
//  ScoreKeeper.swift
//  Concentration
//
//  Created by Mike Yost on 12/9/17.
//  Copyright © 2017 Yost. All rights reserved.
//

import Foundation

class ScoreKeeper {
    private var bestScore = 0
    private func calculateScore(score:Int, elapsedTime:Int) -> Int {

        var floatScore = Double(score)
        switch elapsedTime {
        case  0...20 : floatScore *= 5.0; print ("Bonus: * 5")
        case 21...40 : floatScore *= 3.0; print ("Bonus: * 3")
        case 41...60 : floatScore *= 1.5; print ("Bonus: * 1.5")
        default:                          print ("No Bonus")
            break
        }
        let intScore = Int(floatScore)

        return intScore
    }
    func saveScore(score:Int, elapsedTime:Int) -> Int {
        return calculateScore(score:score, elapsedTime:elapsedTime)
    }
    func saveFinalScore(score:Int, elapsedTime:Int) -> Void {
        let intScore = calculateScore(score: score, elapsedTime: elapsedTime)
        if (intScore>bestScore) {
            bestScore = intScore
        }
    }
    func getBestScore() -> Int {
        return bestScore
    }
}
