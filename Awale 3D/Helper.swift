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
    var node = SCNNode()
    var map = [SCNNode]()
    var scene = 0
        
    var clicked : Bool
    
    let ally = Menu.createMenuText("Your boxes", size: 4)
    let enemy = Menu.createMenuText("Enemy boxes", size: 4)
    
    init() {
        ally.position = SCNVector3(-25, -27, 0)
        enemy.position = SCNVector3(-15, -11, 0)
        ally.opacity = 0
        enemy.opacity = 0
        node = SCNNode()
        clicked = false
        
        createMap()
        prepareScene(0)
    }
    
    func createMap() {
        node = SCNNode()
        map = [SCNNode]()
        for i in 0..<6 {
            let id : Float = (i / 3 == 1) ? -1 : 1
            let start : Float = (i / 3 == 1) ? -25 : 5
            
            let unit = Unit.newNodeWithUnit(Unit.newCase(), pos: SCNVector3(start - Float(i % 3) * 15 * id, -25 + Float(i / 3) * 15, 0), parent: nil)
            map.append(unit)
            node.addChildNode(unit)
        }
    }
    
    func act() {
        switch scene {
        case 0:
            var action = SCNAction.sequence([
                SCNAction.waitForDuration(1),
                SCNAction.moveByX(30, y: 0, z: 0, duration: 0.5),
                SCNAction.waitForDuration(0.5),
                SCNAction.moveByX(-30, y: 0, z: 0, duration: 0.5)
                ])
            let action2 = SCNAction.sequence([
                SCNAction.waitForDuration(1),
                SCNAction.moveByX(-30, y: 0, z: 0, duration: 0.5),
                SCNAction.waitForDuration(0.5),
                SCNAction.moveByX(30, y: 0, z: 0, duration: 0.5)
                ])
            for i in 0..<3 {
                map[i].runAction(SCNAction.repeatActionForever(action), forKey: "act0")
            }
            for i in 3..<6 {
                map[i].runAction(SCNAction.repeatActionForever(action2), forKey: "act0")
            }
            action = SCNAction.sequence([
                SCNAction.waitForDuration(1),
                SCNAction.fadeInWithDuration(0.5),
                SCNAction.waitForDuration(0.5),
                SCNAction.fadeOutWithDuration(0.5),
                ])
            ally.runAction(SCNAction.repeatActionForever(action))
            enemy.runAction(SCNAction.repeatActionForever(action))
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
        case 5:
            for i in 2..<5 {
                Unit.moveUnit(map[1], new: map[i], id: i, origin: 1, max: 6)
            }
        case 6:
            for i in 0..<6 {
                map[i].runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(CGRand(), y: CGRand(), z: CGRand(), duration: 0.5)))
            }
        default: break
        }
        clicked = true
    }
    
    func prepareScene(idScene: Int) {
        scene = idScene
        clicked = false
        switch scene {
        case 0:
            clicked = true
            node.addChildNode(ally)
            node.addChildNode(enemy)
            act()
        case 1:
            createMap()
            for j in 0..<3 {
                Unit.newNodeWithUnit(Unit.newUnit(), pos: Unit.getPositionOnCase(j), parent: map[0])
            }
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
        case 5:
            createMap()
            
            let pos = [2, 3, 0, 0, 0, 0]

            for i in 0..<6 {
                for j in 0..<pos[i] {
                    Unit.newNodeWithUnit(Unit.newUnit(), pos: Unit.getPositionOnCase(j), parent: map[i])
                }
            }
        case 6:
            clicked = true
            createMap()
            act()
        default: break
        }
    }
}
