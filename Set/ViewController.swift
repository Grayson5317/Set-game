//
//  ViewController.swift
//  Set
//
//  Created by 杨浩 on 2020/2/26.
//  Copyright © 2020 Grayson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var set = Set()
    var selectedButtonsIndex = [NSInteger]()
    var score = 0 { didSet{scoreLabel.text = "Score：\(score)" } }
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var deal3MoreCardsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let tempBtn = cardButtons[index]
            tempBtn.setTitle(nil, for: .normal)
            if index < set.cardsOnTable.count {
                tempBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25)
                tempBtn.setAttributedTitle(getAttributedStr(from: set.cardsOnTable[index]), for: .normal)
            } else {
                break
            }
        }
    }
    
    func getAttributedStr(from card: Card) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : modelToView.colors[card.color]!.withAlphaComponent(modelToView.alpha[card.fill]!),
            .strokeWidth : modelToView.strokeWidth[card.fill]!
        ]
        var string = modelToView.shapes[card.shape]!
        
        switch card.number {
        case .two:
            string = "\(string)\(string)"
        case .three:
            string = "\(string)\(string)\(string)"
        default: break
        }
        
        return NSAttributedString.init(string: string, attributes: attributes)
    }
    
    struct modelToView {
        static let colors: [CardView.color : UIColor] = [.red : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), .green : #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), .purple : #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), .none : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)]
        static let alpha: [CardView.fill: CGFloat] = [.solid : 1.0, .hollow : 1.0, .stripe : 0.15, .none : 0.0]
        static let strokeWidth: [CardView.fill: CGFloat] = [.solid : -5.0, .hollow : 5.0, .stripe : -5.0, .none : 0.0]
        static let shapes: [CardView.shape: String] = [.circle : "●", .triangle : "▲", .rectangle : "■", .none : ""]
    
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        if set.isMatched {
            if isDeckEmpty() {
                selectedButtonsIndex.forEach() {set.cardsOnTable[$0] = Card(number: .zero, shape: .none, fill: .none, color: .none)}
                setSelectedBtnEnable(to: false)
                for index in selectedButtonsIndex {
                    cardButtons[index].layer.borderColor = UIColor.clear.cgColor
                }
                selectedButtonsIndex.removeAll()
            } else {
                selectedButtonsIndex.forEach() {set.cardsOnTable[$0] = set.draw1card()}
                setSelectedBtnEnable(to: true)
            }
            updateViewFromModel()
            set.isMatched = false
        }
        
        let cardIndex = cardButtons.firstIndex(of: sender)
        if cardIndex! < set.cardsOnTable.count {
            if selectedButtonsIndex.contains(cardIndex!) {
                sender.layer.borderColor = UIColor.clear.cgColor
                if selectedButtonsIndex.count > 1 {
                    score -= 1
                }
                selectedButtonsIndex.remove(at: selectedButtonsIndex.firstIndex(of: cardIndex!)!)
            } else {
                // can't click more than 3 cards
                if selectedButtonsIndex.count > 2 {
                    setSelectedBtnEnable(to: true)
                    cardButtons.forEach() { $0.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)}
                    selectedButtonsIndex.removeAll()
                }
                
                sender.layer.borderWidth = 3.0
                sender.layer.borderColor = UIColor.yellow.cgColor
                selectedButtonsIndex.append(cardIndex!)
                determineSet()
            }
        }
    }
    
    private func determineSet() {
        if selectedButtonsIndex.count == 3 {
            let result = set.judgeSet(from: selectedButtonsIndex[0], index2: selectedButtonsIndex[1], index3: selectedButtonsIndex[2])
            if result {
                setSelectedBtnBorderColor(to: UIColor.green.cgColor)
                set.isMatched = true
                setSelectedBtnEnable(to: false)
                score += 3
            } else {
                setSelectedBtnBorderColor(to: UIColor.red.cgColor)
                setSelectedBtnEnable(to: false)
                score -= 5
            }
        }
    }
    
    @IBAction func newGameClick(_ sender: Any) {
        set.isMatched = false
        set.resetSet()
        selectedButtonsIndex.removeAll()
        cardButtons.forEach() {
            $0.setAttributedTitle(nil, for: .normal)
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.isEnabled = true
        }
        deal3MoreCardsButton.isEnabled = true
        updateViewFromModel()
        score = 0
    }
    
    @IBAction func deal3MoreCardsClick(_ sender: UIButton) {
        if set.isMatched {
            setSelectedBtnBorderColor(to: UIColor.clear.cgColor)
            if isDeckEmpty() {
                selectedButtonsIndex.forEach() {set.cardsOnTable[$0] = Card(number: .zero, shape: .none, fill: .none, color: .none)}
                setSelectedBtnEnable(to: false)
            } else {
                selectedButtonsIndex.forEach() {set.cardsOnTable[$0] = set.draw1card()}
                setSelectedBtnEnable(to: true)
            }
            updateViewFromModel()
            set.isMatched = false
        } else {
            if set.cardsOnTable.count != cardButtons.count {
                set.draw3Cards()
                updateViewFromModel()
            }
        }
        // empty "if" just for deal with warning
        if isDeckEmpty(){
            
        }
    }
    
    @IBAction func cheatBtnClick(_ sender: Any) {
        set.cheat()
        if !set.cheatCardsIndex.isEmpty {
            score -= 4
            for button in cardButtons {
                button.layer.borderColor = UIColor.clear.cgColor
                button.isEnabled = true
            }
            selectedButtonsIndex.removeAll()
            for index in set.cheatCardsIndex {
                cardButtons[index].layer.borderColor = UIColor.blue.cgColor
                cardButtons[index].layer.borderWidth = 3.0
            }
        }
    }
    
    private func isDeckEmpty() -> Bool {
        if set.deck.isEmpty {
            deal3MoreCardsButton.isEnabled = false
            return true
        } else {
            return false
        }
    }
    
    private func setSelectedBtnEnable(to isEnabled: Bool) {
        selectedButtonsIndex.forEach() {cardButtons[$0].isEnabled = isEnabled}
    }
    
    private func setSelectedBtnBorderColor(to color: CGColor) {
        selectedButtonsIndex.forEach() {cardButtons[$0].layer.borderColor = color}
    }
}


