//
//  Game.swift
//  Loteria
//
//  Created by Mauricio Miyamura on 03/04/18.
//  Copyright © 2018 Yuddi. All rights reserved.
//

import Foundation

infix operator >-<
func >-< (quantity: UInt8, total: UInt8) -> [Int] {
    var result: [Int] = []
    while result.count < quantity {
        let number = Int(arc4random_uniform(UInt32(total)) + 1)
        if !result.contains(number) {
            result.append(number)
        }
    }
    return result
}

class Game {
    var name: String
    
    let quantity: UInt8
    let total: UInt8
    
    private var _numbers: [Int]
    var numbers: [Int] {
        return _numbers
    }
    
    init(_ name: String, _ quantity: UInt8, _ total: UInt8) {
        self.name = name
        self.quantity = min(quantity, total)
        self.total = total
        _numbers = quantity >-< total
    }
    
    func updateNumbers() {
        _numbers = quantity >-< total
    }
    
    func update(number: Int) -> Int? {
        if let index = _numbers.index(of: number) {
            var newNumber = number
            while _numbers.contains(newNumber) {
                newNumber = Int(arc4random_uniform(UInt32(total)) + 1)
            }
            _numbers[index] = newNumber
            return newNumber
        }
        return nil
    }
}
