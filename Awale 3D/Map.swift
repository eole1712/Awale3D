//
//  Map.swift
//  Ebola3D
//
//  Created by Grisha Ghukasyan on 02/01/2016.
//  Copyright © 2016 Grisha Ghukasyan. All rights reserved.
//

import SceneKit
import UIKit

class Map {
    
    var             map : SCNNode
    
    var             _map = [(Int, SCNNode, Bool)]()
    
    private let     _boxSize : Float = 15.0
    private let     _startMapX : Float
    private let     _startMapY : Float
    
    var wasNoMove = false
    
    let player1 = SCNText()
    let player2 = SCNText()
    
    var players = [0, 0]
    var turn = 0
    var endGame = false
    
    var night : Bool
    
    init(night: Bool) {
        self.night = night
        _startMapX = _boxSize * 3.0
        _startMapY = _boxSize * 2.0
        
        player1.string = "Player 1 : " + String(players[0])
        player2.string = "Player 2 : " + String(players[1])
        player1.font = UIFont(name: (player1.font?.fontName)!, size: 3)
        player2.font = UIFont(name: (player2.font?.fontName)!, size: 3)
        
        map = SCNNode()
        
        for i in 0..<12 {
            
            let id : Float = (i / 6 == 1) ? -1 : 1
            let start : Float = (i / 6 == 1) ? -45 : 30
            
            let position = SCNVector3Make(start - (_boxSize * id * Float(i % 6)), (Float(i / 6) * _boxSize) - _startMapY, 0)
            
            let unit = Unit.newNodeWithUnit(Unit.newCase(night), pos: position, parent: map)
            if (i < 6 || i == 11) {
            for j in 0..<4 {
                Unit.newNodeWithUnit(Unit.newUnit(night), pos: Unit.getPositionOnCase(j), parent: unit)
            }
            }
            
            _map.append((i < 6 || i == 11 ? 4 : 0, unit, false))
        }
        changeTurn(false)
    }
    
    func checkEnd() -> Bool {
        var nb = 0
        
        for i in 0..<12 {
            if ((turn == 0 && i < 6) || (turn == 1 && i >= 6)) {
                nb += _map[i].0
            }
        }
        if (players[0] >= 25 || players[1] >= 25) {
            return true
        }
        return ((nb > 0) ? false : true)
    }
    
    func hasNoMove(turn: Int) -> Bool {
        for i in (turn == 0 ? 0..<6 : 6..<12) {
            if (_map[i].0 > 0) {
                return false
            }
        }
        return true
    }
    
    func getTurn(id: Int) -> Int {
        if (id < 6) {
            return 0
        }
        return 1
    }
    
    func changeTurn(needChange: Bool) {
        if (needChange) {
            turn = (turn == 0 ? 1 : 0)
        }
        for i in 0..<12 {
            if ((turn == 0 && i < 6) || (turn ==  1 && i >= 6))
            {
                _map[i].1.runAction(SCNAction.rotateByAngle(0.4, aroundAxis: SCNVector3((turn == 0 ? 1 : -1), 0, 0), duration: 0.5))
            }
            else if (needChange) {
                _map[i].1.runAction(SCNAction.rotateByAngle(0.4, aroundAxis: SCNVector3((turn == 0 ? 1 : -1), 0, 0), duration: 0.5))
            }
        }
        var total = 0
        if (hasNoMove(turn == 0 ? 1 : 0)) {
            for i in (turn == 0 ? 0..<6 : 6..<12) {
                if (getTurn(i + _map[i].0) == turn){
                    total++
                    _map[i].2 = true
                    _map[i].1.geometry?.firstMaterial!.transparency = 0.2
                    for node in _map[i].1.childNodes {
                        node.geometry?.firstMaterial!.transparency = 0.8
                    }
                }
            }
            wasNoMove = true
            if (total == 6) {
                refresh()
            }
        }
    }
    
    func refreshScore() {
        player1.string = "Player 1 : " + String(players[0])
        player2.string = "Player 2 : " + String(players[1])
    }
    
    func howMuchCanEat(c: Int) -> Int {
        let t = (c >= 6 ? 1 : 0)
        
        
        var value = _map[c].0;
        var score = 0
        
        var i = (c + 1) % 12;
        
        while (value > 0) {
            if (i == c) {
                i = (i + 1) % 12;
            }
            value--
            if (value > 0) {
                i = (i + 1) % 12;
            }
        }
        
        while (((t == 0 && i >= 6) || (t == 1 && i < 6 && i >= 0)) && (_map[i].0 == 1 || _map[i].0 == 2)) {
            score += _map[i].0 + 1
            i--;
        }
        return score
    }
    
    func canBeEatenFrom(c: Int, from: Int) -> Bool {
        if (_map[c].0 != 1 && _map[c].0 != 2) {
            return false
        }
        
        let turn = from < 6 ? 0 : 1
        let id = (from + _map[from].0) % 12
        
        if (id == c) {
            return true
        } else if ((turn == 0 && id < 6) || (turn == 1 && id >= 6)) {
            return false
        } else if (id > c) {
            for (var i = id; i > c; i--) {
                if (canBeEatenFrom(i, from: from) == false) {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func canBeEaten(c: Int) -> Bool {
        if (_map[c].0 != 1 && _map[c].0 != 2) {
            return false
        }
        
        for i in (c >= 6 ? 0..<6 : 6..<12) {
            if (canBeEatenFrom(c, from: i) == true) {
                return true
            }
        }
        return false
    }
    
    func refresh() {
        if (wasNoMove) {
            for i in (turn == 0 ? 0..<6 : 6..<12) {
                if (_map[i].2 == true) {
                    _map[i].1.geometry?.firstMaterial!.transparency = 0.4
                    for node in _map[i].1.childNodes {
                        node.geometry?.firstMaterial!.transparency = 1
                    }
                    _map[i].2 = false
                }
            }
            wasNoMove = false
        }
    }
    
    func doAction(c: Int, var time: Double = 0.0) -> Double {
        var value = _map[c].0;
        _map[c].0 = 0;
        
        refresh()
        
        var i = (c + 1) % 12;
        
        while (value > 0) {
            if (i == c) {
                i = (i + 1) % 12;
            }
            _map[i].0 += 1;
            Unit.moveUnit(_map[c].1, new: _map[i].1, id: i, origin: c, max: 12, time: time)
            value--;
            if (value > 0) {
                i = (i + 1) % 12;
            }
        }
        
        time += 1.0
        
        while (((turn == 0 && i >= 6) || (turn == 1 && i < 6 && i >= 0)) && (_map[i].0 == 2 || _map[i].0 == 3)) {
            players[turn] += _map[i].0
            _map[i].0 = 0
            Unit.clearNode(_map[i].1, time: time)
            time += 0.3
            i--;
        }
        
        refreshScore()
        changeTurn(true)
        endGame = checkEnd()
        return time
    }
    
    func showPrediction(c: Int, state: UIGestureRecognizerState) {
        
        var value = _map[c].0;
        var i = (c + 1) % 12;
        
        while (value > 0) {
            if (i == c) {
                i = (i + 1) % 12;
            }
            value--
            if (value > 0) {
                i = (i + 1) % 12;
            }
        }
        
        while (((turn == 0 && i >= 6) || (turn == 1 && i < 6 && i >= 0)) && (_map[i].0 == 1 || _map[i].0 == 2)) {
            if (state == .Began) {
                Unit.selectNode(_map[i].1)
            }
            i--;
        }
    }
    
    func actOnSimulateTab(inout tab: [Int], c: Int) -> Int {
        var score = 0
        
        var value = tab[c]
        tab[c] = 0
        
        var i = (c + 1) % 12
        while (value > 0) {
            if (i == c) {
                i = (i + 1) % 12
            }
            value--
            tab[i]++
            if (value > 0) {
                i = (i + 1) % 12
            }
        }
        
        while (((turn == 0 && i >= 6) || (turn == 1 && i < 6 && i >= 0)) && (tab[i] == 2 || tab[i] == 3)) {
            score += tab[i]
            tab[i] == 0
            i--;
        }
        return score
    }
    
    func simulateMove(c: Int) -> Int {
        var tab = [Int]()
        var score = 0
        
        for i in 0..<12 {
            tab.append(_map[i].0)
        }
        
        actOnSimulateTab(&tab, c: c)
        
        for i in (turn == 0 ? 6..<12 : 0..<6) {
            score += actOnSimulateTab(&tab, c: i)
        }
        
        return score
    }
    
    func findNodeAction(parent: SCNNode, child: SCNNode) -> Int?
    {
        var i = 0
        
        for unit in parent.childNodes {
            if (unit == child) {
                return i
            }
            i++
        }
        return nil
    }
    
    func endGameAction() {
        for i in 0..<12 {
            _map[i].1.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(CGRand(), y: CGRand(), z: CGRand(), duration: 0.5)))
        }
    }
}