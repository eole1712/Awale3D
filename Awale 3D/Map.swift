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
    
    var             _map = [(Int, SCNNode)]()
    
    private let     _boxSize : Float = 15.0
    private let     _startMapX : Float
    private let     _startMapY : Float
    
    let player1 = SCNText()
    let player2 = SCNText()
    
    var players = [0, 0]
    var turn = 0
    var endGame = false
    
    init() {
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
            
            let unit = Unit.newNodeWithUnit(Unit.newCase(), pos: position, parent: map)
            for j in 0..<4 {
                Unit.newNodeWithUnit(Unit.newUnit(), pos: Unit.getPositionOnCase(j), parent: unit)
            }
            
            _map.append((4, unit))
        }
        changeTurn(false)
    }
    
    func checkEnd() -> Bool {
        var nb = 0
        var total = 0
        
        for i in 0..<12 {
            if ((turn == 0 && i < 6) || (turn == 1 && i >= 6)) {
                nb += _map[i].0
            }
            total += _map[i].0
        }
        return ((total > 6 && nb > 0) ? false : true)
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
    }
    
    func refreshScore() {
        player1.string = "Player 1 : " + String(players[0])
        player2.string = "Player 2 : " + String(players[1])
    }
    
    func doAction(c: Int)
    {
        if (c > 12) {
            return
        }
        
        var value = _map[c].0;
        _map[c].0 = 0;
        
        var i = (c + 1) % 12;
        
        while (value > 0) {
            if (i == c) {
                i = (i + 1) % 12;
            }
            _map[i].0 += 1;
            Unit.moveUnit(_map[c].1, new: _map[i].1, id: i, origin: c, max: 12)
            value--;
            if (value > 0) {
                i = (i + 1) % 12;
            }
        }
        var t = 0
        while (((turn == 0 && i >= 6) || (turn == 1 && i < 6 && i >= 0)) && (_map[i].0 == 2 || _map[i].0 == 3)) {
            players[turn] += _map[i].0
            _map[i].0 = 0
            Unit.clearNode(_map[i].1, time: t)
            t++;
            i--;
        }
        
        refreshScore()
        changeTurn(true)
        endGame = checkEnd()
    }
    
    func showPrediction(c: Int, state: UIGestureRecognizerState) {
        if (c > 12) {
            return
        }
        
        var value = _map[c].0;
        
        var i = (c + 1) % 12;
        
        while (value > 0) {
            if (i == c) {
                i = (i + 1) % 12;
            }
            value--;
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
    
    func findNodeAction(parent: SCNNode, child: SCNNode) -> Int
    {
        var i = 0
        
        for unit in parent.childNodes {
            if (unit == child) {
                return i
            }
            i++
        }
        return 12
    }
}