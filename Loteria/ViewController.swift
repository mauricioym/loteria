//
//  ViewController.swift
//  Loteria
//
//  Created by Mauricio Miyamura on 02/04/18.
//  Copyright © 2018 Yuddi. All rights reserved.
//

import UIKit

extension UIButton {
    var number: Int {
        get {
            return self.tag
        }
        set {
            self.setTitle("\(newValue)", for: .normal)
            self.tag = newValue
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet var btBalls: [UIButton]!
    @IBOutlet weak var swOrdering: UISwitch!
    
    var megasena = Game("Mega-Sena", 6, 60)
    var quina = Game("Quina", 5, 80)
    var gameSelected: Game!
    var ascending = false
    var orderIsBroken = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameSelected = megasena
        updateBalls()
    }

    @IBAction func changeGameType(_ sender: UISegmentedControl) {
        gameSelected = sender.selectedSegmentIndex == 0 ? megasena : quina
        lbTitle.text = gameSelected.name
        updateBalls()
    }
    
    @IBAction func changeBall(_ sender: UIButton) {
        if let newNumber = gameSelected.update(number: sender.number) {
            sender.number = newNumber
            
            if ascending && orderBroken() {
                swOrdering.onTintColor = .red
                orderIsBroken = true
            } else {
                swOrdering.onTintColor = nil
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
            btBalls[index].number = number
        }
        
        if ascending && orderIsBroken {
            orderIsBroken = false
            swOrdering.onTintColor = nil
        }
    
    }
    
    func orderBroken() -> Bool {
        let numbers = gameSelected.numbers.sorted()
        for (index, number) in numbers.enumerated() {
            if btBalls[index].number != number {
                return true
            }
        }
        return false
    }
    
}

