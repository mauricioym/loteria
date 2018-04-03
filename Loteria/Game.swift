//
//  Game.swift
//  Loteria
//
//  Created by Mauricio Miyamura on 03/04/18.
//  Copyright © 2018 Yuddi. All rights reserved.
//

import Foundation

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

class Game {
    var name: String
    var quantity: Int
    var total: Int
    var numbers: [Int]
    
    init(_ name: String, _ quantity: Int, _ total: Int) {
        self.name = name
        self.quantity = quantity
        self.total = total
        numbers = quantity >-< total
    }
    
    func updateNumbers() {
        numbers = quantity >-< total
    }
    
    func update(number: Int) -> Int? {
        if let index = numbers.index(of: number) {
            var newNumber = number
            while numbers.contains(newNumber) {
                newNumber = Int(arc4random_uniform(UInt32(total)) + 1)
            }
            numbers[index] = newNumber
            return newNumber
        } else {
            return nil
        }
    }
}
