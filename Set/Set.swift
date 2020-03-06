//
//  PlayingCardDeck.swift
//  Set
//
//  Created by 杨浩 on 2020/2/26.
//  Copyright © 2020 Grayson. All rights reserved.
//

import Foundation

struct Set {
    var isMatched = false
    private(set) var deck = [Card]()
    var cardsOnTable = [Card]()
    var cheatCardsIndex = [NSInteger]()
    
    init() {
        initDeck()
        draw12Cards()
    }
    
    private mutating func initDeck() {
        for n in CardView.number.all {
            for c in CardView.color.all {
                for s in CardView.shape.all {
                    for f in CardView.fill.all {
                        let tempCard = Card(number: n, shape: s, fill: f, color: c)
                        deck.append(tempCard)
                    }
                }
            }
        }
    }
                    
    private mutating func draw12Cards() {
        for _ in 1...12 {
            cardsOnTable.append(deck.remove(at: deck.count.arc4random))
        }
    }
    
    mutating func draw3Cards() {
        for _ in 1...3 {
            cardsOnTable.append(deck.remove(at: deck.count.arc4random))
        }
    }
    
    mutating func draw1card() -> Card{
        return deck.remove(at: deck.count.arc4random)
    }
    
    mutating func resetSet() {
        cardsOnTable.removeAll()
        deck.removeAll()
        initDeck()
        draw12Cards()
    }
    
    mutating func cheat() {
        cheatCardsIndex.removeAll()
        for i in 0..<cardsOnTable.count {
            for j in (i+1)..<cardsOnTable.count {
                for k in (j+1)..<cardsOnTable.count {
                    if judgeSet(from: i, index2: j, index3: k) {
                        cheatCardsIndex += [i, j, k]
                        return
                    }
                }
            }
        }
    }
    
    func judgeSet(from index1:NSInteger, index2:NSInteger, index3:NSInteger) -> Bool{
        if (cardsOnTable[index1].color == cardsOnTable[index2].color
            && cardsOnTable[index1].color == cardsOnTable[index3].color
            && cardsOnTable[index2].color == cardsOnTable[index3].color)
            || (cardsOnTable[index1].color != cardsOnTable[index2].color
            && cardsOnTable[index1].color != cardsOnTable[index3].color
            && cardsOnTable[index2].color != cardsOnTable[index3].color){
           
            if (cardsOnTable[index1].fill == cardsOnTable[index2].fill
            && cardsOnTable[index1].fill == cardsOnTable[index3].fill
            && cardsOnTable[index2].fill == cardsOnTable[index3].fill)
            || (cardsOnTable[index1].fill != cardsOnTable[index2].fill
            && cardsOnTable[index1].fill != cardsOnTable[index3].fill
            && cardsOnTable[index2].fill != cardsOnTable[index3].fill) {
                
                if (cardsOnTable[index1].number == cardsOnTable[index2].number
                && cardsOnTable[index1].number == cardsOnTable[index3].number
                && cardsOnTable[index2].number == cardsOnTable[index3].number)
                || (cardsOnTable[index1].number != cardsOnTable[index2].number
                && cardsOnTable[index1].number != cardsOnTable[index3].number
                && cardsOnTable[index2].number != cardsOnTable[index3].number) {
                    
                    if (cardsOnTable[index1].shape == cardsOnTable[index2].shape
                    && cardsOnTable[index1].shape == cardsOnTable[index3].shape
                    && cardsOnTable[index2].shape == cardsOnTable[index3].shape)
                    || (cardsOnTable[index1].shape != cardsOnTable[index2].shape
                    && cardsOnTable[index1].shape != cardsOnTable[index3].shape
                    && cardsOnTable[index2].shape != cardsOnTable[index3].shape) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}


