//
//  Unit.swift
//  Ebola3D
//
//  Created by Grisha Ghukasyan on 02/01/2016.
//  Copyright © 2016 Grisha Ghukasyan. All rights reserved.
//

import SceneKit
import UIKit

class Unit {
    
    class func getPositionOnCase(p: Int) -> SCNVector3 {
        struct Position {
            
            static let sphereSize : Float = 3.0
            
            static let pos : [SCNVector3] = [ SCNVector3Make(0, 0, 0),
                SCNVector3Make(sphereSize, 0, 0),
                SCNVector3Make(-1 * sphereSize, 0, 0),
                SCNVector3Make(0, -1 * sphereSize, 0),
                SCNVector3Make(0, sphereSize, 0),
                SCNVector3Make(0, 0, sphereSize),
                SCNVector3Make(0, 0, -1 * sphereSize),
                SCNVector3Make(-1 * sphereSize, -1 * sphereSize, 0),
                SCNVector3Make(-1 * sphereSize, 1 * sphereSize, 0),
                SCNVector3Make(1 * sphereSize, -1 * sphereSize, 0),
                SCNVector3Make(1 * sphereSize, 1 * sphereSize, 0),
                SCNVector3Make(0, -1 * sphereSize, -1 * sphereSize),
                SCNVector3Make(0, -1 * sphereSize, 1 * sphereSize),
                SCNVector3Make(0, 1 * sphereSize, -1 * sphereSize),
                SCNVector3Make(1 * sphereSize, 0, 1 * sphereSize),
                SCNVector3Make(-1 * sphereSize, 0, -1 * sphereSize),
                SCNVector3Make(-1 * sphereSize, 0, 1 * sphereSize),
                SCNVector3Make(1 * sphereSize, 0, -1 * sphereSize),
                SCNVector3Make(1 * sphereSize, 0, 1 * sphereSize)]
        }
        
        return Position.pos[(p < 19 ? p : 0)]
    }
    
    
    class func randColor() -> UIColor {
        
        let randomRed:CGFloat = CGFloat(drand48()) - 50.0
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    
    class func newUnit(night: Bool) -> SCNGeometry {
        let unit = SCNSphere(radius: 2.0)
        unit.firstMaterial!.diffuse.contents = night ? UIColor.whiteColor() : UIColor.grayColor()
        unit.firstMaterial!.specular.contents = night ? UIColor.grayColor() : UIColor.whiteColor()
        
        return unit
    }
    
    class func newCase(night: Bool) -> SCNGeometry {
        let unit = SCNBox(width: 12, height: 12, length: 12, chamferRadius: 1.0)
        
        unit.firstMaterial!.transparency = 0.4
        if (night) {
            unit.firstMaterial!.diffuse.contents = UIColor.whiteColor()
            unit.firstMaterial!.specular.contents = UIColor.grayColor()
        }
        return unit
    }
    
    class func newNodeWithUnit(unit: SCNGeometry, pos: SCNVector3, parent: SCNNode?) -> SCNNode {
        let node = SCNNode(geometry: unit)
        node.position = pos
        parent?.addChildNode(node)
        return node
    }
    
    class func getPositionIndiceFromID(id: Int, origin: Int, max: Int) -> (Float, Float) {
        let a : Float = origin / (max / 2) == 0 ? Float(origin) : Float(max - 1) - Float(origin)
        let b : Float = id / (max / 2) == 0 ? Float(id) : Float(max - 1) - Float(id)
        let c : Float = (origin / (max / 2)) == (id / (max / 2)) ? 0 : 15 * (origin / (max / 2) == 1 ? 1 : -1)
        return (Float((b - a) * 15), Float(c))
    }
    
    class func moveUnit(old: SCNNode, new: SCNNode, id: Int, origin: Int, max: Int, time: Double = 0.0) {
        let unit = old.childNodes[0]
        let p = new.childNodes.count
        
        let (x, y) = getPositionIndiceFromID(id, origin: origin, max: max)
        
        unit.removeFromParentNode()
        new.addChildNode(unit)
        unit.position = SCNVector3Make(unit.position.x + x, unit.position.y + y, unit.position.z)
        
        unit.runAction(SCNAction.sequence([
            SCNAction.waitForDuration(time),
            SCNAction.moveTo(getPositionOnCase(p), duration: 1)
            ]))
    }
    
    class func clearNode(unit: SCNNode, time: Double = 0.0) {
        let action = SCNAction.sequence([
            SCNAction.waitForDuration(time),
            SCNAction.scaleTo(1.8, duration: 0.3),
            SCNAction.scaleTo(0, duration: 0.2),
            SCNAction.removeFromParentNode()])
        for child in unit.childNodes {
            child.runAction(action)
        }
    }
    
    class func selectNode(unit: SCNNode) {
        unit.runAction(SCNAction.rotateByAngle(CGFloat(2 * M_PI), aroundAxis: SCNVector3(0, 1, 0), duration: 1))
    }
    
    class func emptyNode(unit: SCNNode) {
        unit.runAction(SCNAction.rotateByAngle(CGFloat(2 * M_PI), aroundAxis: SCNVector3(0, 0, 1), duration: 1))
    }
}