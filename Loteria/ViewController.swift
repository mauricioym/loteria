//
//  ViewController.swift
//  Loteria
//
//  Created by Mauricio Miyamura on 02/04/18.
//  Copyright © 2018 Yuddi. All rights reserved.
//

import UIKit

enum GameType: Int {
    case megasena
    case quina
}

infix operator >-<
func >-< (quantity: Int, total: Int) -> [Int] {
    var result: [Int] = []
    if quantity > total {
        return result
    }
    while result.count < quantity {
        let number = Int(arc4random_uniform(UInt32(total)) + 1)
        if !result.contains(number) {
            result.append(number)
        }
    }
    return result
}

class ViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet var btBalls: [UIButton]!
    @IBOutlet weak var swOrdering: UISwitch!
    
    var megasena = 6>-<60
    var quina = 5>-<80
    var gameSelected: GameType = .megasena
    var ascending = false
    var orderIsBroken = false
    var switchDefaultOnTintColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchDefaultOnTintColor = swOrdering.onTintColor
        updateBalls()
    }

    @IBAction func changeGameType(_ sender: UISegmentedControl) {
        gameSelected = GameType(rawValue: sender.selectedSegmentIndex)!
        switch gameSelected {
        case .megasena:
            lbTitle.text = "Mega-Sena"
        case .quina:
            lbTitle.text = "Quina"
        }
        updateBalls()
    }
    
    @IBAction func changeBall(_ sender: UIButton) {
        var newNumber = sender.tag
        
        switch gameSelected {
        case .megasena:
            let index = megasena.index(of: newNumber)
            
            while megasena.contains(newNumber) {
                newNumber = Int(arc4random_uniform(UInt32(60)) + 1)
            }
            
            megasena[index!] = newNumber
        case .quina:
            let index = quina.index(of: newNumber)
            
            while quina.contains(newNumber) {
                newNumber = Int(arc4random_uniform(UInt32(80)) + 1)
            }
            
            quina[index!] = newNumber
        }
        
        sender.setTitle("\(newNumber)", for: .normal)
        sender.tag = newNumber
        if ascending && orderBroken() {
            swOrdering.onTintColor = .red
            orderIsBroken = true
        } else {
            swOrdering.onTintColor = switchDefaultOnTintColor
            orderIsBroken = false
        }
    }
    
    @IBAction func changeOrdering(_ sender: UISwitch) {
        if ascending && orderIsBroken {
            sender.isOn = true
        } else {
            ascending = sender.isOn
        }
        updateBalls()
    }
    
    @IBAction func generate() {
        switch gameSelected {
        case .megasena:
            megasena = 6>-<60
        case .quina:
            quina = 5>-<80
        }
        updateBalls()
    }
    
    func updateBalls() {
        var game: [Int] = []
        
        switch gameSelected {
        case .megasena:
            game = ascending ? megasena.sorted() : megasena
            btBalls.last?.isHidden = false
        case .quina:
            game = ascending ? quina.sorted() : quina
            btBalls.last?.isHidden = true
        }
        
        for (index, number) in game.enumerated() {
            btBalls[index].setTitle("\(number)", for: .normal)
            btBalls[index].tag = number
        }
        
        if ascending && orderIsBroken {
            orderIsBroken = false
            swOrdering.onTintColor = switchDefaultOnTintColor
        }
    }
    
    func orderBroken() -> Bool {
        let game = gameSelected == .megasena ? megasena.sorted() : quina.sorted()
        for (index, number) in game.enumerated() {
            if btBalls[index].tag != number {
                return true
            }
        }
        return false
    }
    
}

