//
//  Theme.swift
//  Concentration
//
//  Created by Mike Yost on 12/8/17.
//  Copyright © 2017 Yost. All rights reserved.
//

import UIKit

class ThemeFactory {
    var themeList = [
        Theme(with:"🦇🙀😲🎃👻🐔🦉🦄🦋",     view:UIColor.black,       card:UIColor.yellow ),
        Theme(with:"🏈🏀⚽️🏉🎱⚾️🎾⛸🏹🏒" ,  view:UIColor.blue,        card:UIColor.lightGray),
        Theme(with:"🥑🥝🍓🍋🍏🍎🍇🌶🥕🍅",   view:UIColor.gray,        card:UIColor.black),
        Theme(with:"🐖🐫🐳🐊🐆🐿🌴🌵🌿☘️",   view:UIColor.white,       card:UIColor.blue),
        Theme(with:"🚲🚜🚀⚓️🚢🚘🚑",          view:UIColor.blue,         card:UIColor.yellow),
        Theme(with:"⏰☎️🎥🔌🗑💡🔦💰",        view:UIColor.black,       card:UIColor.orange),
        Theme(with:"1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣")
        
    ]
    
    var previousThemeIndex = 100
    var nextIndex = 99
    func getNextTheme() -> Theme {
        repeat {
            nextIndex = Int(arc4random_uniform(UInt32(themeList.count)))
        } while nextIndex == previousThemeIndex
        previousThemeIndex = nextIndex
        return themeList[nextIndex]
    }
}

class Theme {
    init(with emojis: String) {
        self.emojis=emojis
    }
    init(with emojis: String, view:UIColor, card:UIColor) {
        self.emojis=emojis
        viewBackgroundColor = view
        cardBackgroundColor = card
    }
    var emojis=String()
    var viewBackgroundColor=UIColor.black
    var cardBackgroundColor=UIColor.orange
}

