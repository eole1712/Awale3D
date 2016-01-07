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
            let start : Float = (i / 3 == 1) ? -25 : 5
            
            let unit = Unit.newNodeWithUnit(Unit.newCase(), pos: SCNVector3(start - Float(i % 3) * 15 * id, -25 + Float(i / 3) * 15, 0), parent: nil)
            map.append(unit)
            node.addChildNode(unit)
        }
        prepareScene(0)
    }
    
    func act() {
        switch scene {
        case 0: break
        case 1:
            for i in 1...3 {
                Unit.moveUnit(map[0], new: map[i], id: i, origin: 0, max: 6)
            }
        case 2:
            Unit.moveUnit(map[2], new: map[3], id: 3, origin: 2, max: 6)
            Unit.clearNode(map[3], time: 0)
        case 3:
            for i in 2..<6 {
                Unit.moveUnit(map[1], new: map[i], id: i, origin: 1, max: 6)
            }
            Unit.clearNode(map[5], time: 0)
            Unit.clearNode(map[4], time: 1)
        case 4:
            map[4].runAction(SCNAction.repeatActionForever(SCNAction.rotateByAngle(CGFloat(M_PI * 2), aroundAxis: SCNVector3(0, 1, 0), duration: 1)))
            map[5].runAction(SCNAction.repeatActionForever(SCNAction.rotateByAngle(CGFloat(M_PI * 2), aroundAxis: SCNVector3(0, 1, 0), duration: 1)))
        default: break
        }
        clicked = true
    }
    
    func prepareScene(idScene: Int) {
        scene = idScene
        clicked = false
        switch scene {
        case 0: clicked = true
        case 1:
            for j in 0..<3 {
                Unit.newNodeWithUnit(Unit.newUnit(), pos: Unit.getPositionOnCase(j), parent: map[0])
            }
        case 2: break
        case 3:
            let pos = [0, 3, 0, 4, 1, 2]
            
            for i in 0..<6 {
                for j in 0..<pos[i] {
                    Unit.newNodeWithUnit(Unit.newUnit(), pos: Unit.getPositionOnCase(j), parent: map[i])
                }
            }
        case 4:
            let pos = [0, 0, 3, 0, 1, 2]
            
            for i in 0..<6 {
                for j in 0..<pos[i] {
                    Unit.newNodeWithUnit(Unit.newUnit(), pos: Unit.getPositionOnCase(j), parent: map[i])
                }
            }
        default: break
        }
    }
}
