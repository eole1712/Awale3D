//
//  Helper.swift
//  Awale 3D
//
//  Created by Grisha Ghukasyan on 05/01/2016.
//  Copyright © 2016 Grisha Ghukasyan. All rights reserved.
//

import SceneKit
import UIKit

class Helper {
    let node : SCNNode
    var map = [SCNNode]()
    var scene = 0
    
    var clicked : Bool
    
    init() {
        node = SCNNode()
        clicked = false
        
        for i in 0..<6 {
            let id : Float = (i / 3 == 1) ? -1 : 1
            let start : Float = (i / 3 == 1) ? -50 : -20
            
            let unit = Unit.newNodeWithUnit(Unit.newCase(), pos: SCNVector3(start - Float(i % 3) * 15 * id, -20 + Float(i / 3) * 15, 0), parent: nil)
            if (i == 0) {
                for j in 0..<3 {
                    Unit.newNodeWithUnit(Unit.newUnit(), pos: Unit.getPositionOnCase(j), parent: unit)
                }
            }
            map.append(unit)
            node.addChildNode(unit)
        }
    }
    
    func act() {
        switch scene {
        case 0:
            for i in 1...3 {
                Unit.moveUnit(map[0], new: map[i], id: i, origin: 0, max: 6)
            }
        case 1:
            Unit.moveUnit(map[2], new: map[3], id: 3, origin: 2, max: 6)
            Unit.clearNode(map[3])
        case 2:
            map[3].runAction(SCNAction.repeatActionForever(SCNAction.rotateByAngle(CGFloat(M_PI * 2), aroundAxis: SCNVector3(0, 1, 0), duration: 1)))
        default: break
        }
        clicked = true
    }
    
    func prepareScene(idScene: Int) {
        scene = idScene
        clicked = false
        switch scene {
        case 0: break
        case 1: break
        case 2:
            Unit.newNodeWithUnit(Unit.newUnit(), pos: Unit.getPositionOnCase(0), parent: map[2])
            Unit.newNodeWithUnit(Unit.newUnit(), pos: Unit.getPositionOnCase(0), parent: map[3])
        default: break
        }
    }
}
