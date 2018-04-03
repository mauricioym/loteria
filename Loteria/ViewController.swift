//
//  ViewController.swift
//  Loteria
//
//  Created by Mauricio Miyamura on 02/04/18.
//  Copyright © 2018 Yuddi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet var btBalls: [UIButton]!
    @IBOutlet weak var swOrdering: UISwitch!
    
    var megasena = Game("Mega-Sena", 6, 60)
    var quina = Game("Quina", 5, 80)
    var gameSelected: Game!
    var ascending = false
    var orderIsBroken = false
    var switchDefaultOnTintColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameSelected = megasena
        switchDefaultOnTintColor = swOrdering.onTintColor
        updateBalls()
    }

    @IBAction func changeGameType(_ sender: UISegmentedControl) {
        gameSelected = sender.selectedSegmentIndex == 0 ? megasena : quina
        lbTitle.text = gameSelected.name
        updateBalls()
    }
    
    @IBAction func changeBall(_ sender: UIButton) {
        if let newNumber = gameSelected.update(number: sender.tag) {
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
        gameSelected.updateNumbers()
        updateBalls()
    }
    
    func updateBalls() {
        let numbers = ascending ? gameSelected.numbers.sorted() : gameSelected.numbers
        
        btBalls.last?.isHidden = (numbers.count == 5)
        
        for (index, number) in numbers.enumerated() {
            btBalls[index].setTitle("\(number)", for: .normal)
            btBalls[index].tag = number
        }
        
        if ascending && orderIsBroken {
            orderIsBroken = false
            swOrdering.onTintColor = switchDefaultOnTintColor
        }
    
    }
    
    func orderBroken() -> Bool {
        let numbers = gameSelected.numbers.sorted()
        for (index, number) in numbers.enumerated() {
            if btBalls[index].tag != number {
                return true
            }
        }
        return false
    }
    
}

