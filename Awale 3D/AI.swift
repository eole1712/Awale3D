//
//  AI.swift
//  Awale 3D
//
//  Created by Grisha Ghukasyan on 08/01/2016.
//  Copyright © 2016 Grisha Ghukasyan. All rights reserved.
//

import Foundation

class AI {
    
    let map : Map
    let turn : Int
    
    init(map: Map, turn: Int) {
        self.map = map
        self.turn = turn
    }
    
    private func tryToEat() -> (id: Int, score: Int)? {
        var (id, score) = (-1, 0)
        
        for i in (turn == 1 ? 6..<12 : 0..<6) {
            let a = map.howMuchCanEat(i)
            
            if (a > score) {
                (id, score) = (i, a)
            }
        }
        if (id == -1) {
            return nil
        }
        return (id, score)
    }
    
    private func soloSphereCheck() -> Int? {
        for (var i = (turn == 1 ? 11 : 5); i >= (turn == 1 ? 6 : 0); i--) {
            if (map.canBeEaten(i) == true) {
                if (i == (turn == 0 ? 5 : 11) || map._map[i + 1].0 > 1) {
                    return i
                }
            }
        }
        return nil
    }
    
    private func getPlayableCases() -> [Int]? {
        var tab = [Int]()
        
        for i in (turn == 1 ? 6..<12 : 0..<6) {
            if (map.simulateMove(i) == 0) {
                tab.append(i)
            }
        }
        if (tab.count == 0) {
            return nil
        }
        return tab
    }
    
    private func doAction() -> Int? {
        if let canEat = tryToEat() {
            if (canEat.score > 0) {
                return canEat.id
            }
        }
        
        if let canBeEaten = soloSphereCheck() {
            return canBeEaten
        }

        if let tab = getPlayableCases() {
            let randAct : Int = Int(arc4random_uniform(UInt32(tab.count)))
            return tab[randAct]
        }
        
        let randAct : Int = (turn * 6) + Int(arc4random_uniform(6))
        if (map._map[randAct].0 > 0) {
            return randAct
        }
          
        return nil
    }
    
    func nextAction() -> Int? {
        
        if let action = doAction() {
            if (turn == 0 && action >= 0 && action < 6 && map._map[action].0 > 0) {
                return action
            }
            if (turn == 1 && action >= 6 && action < 12 && map._map[action].0 > 0) {
                return action
            }
        }
        for i in (turn == 1 ? 6..<12 : 0..<6) {
            if (map._map[i].0 > 0) {
                return i
            }
        }
        return nil
    }
}