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
    
    static let sphereSize : Float = 3.0
    
    static let pos = [ SCNVector3Make(sphereSize, 0, 0),
        SCNVector3Make(-1 * sphereSize, 0, 0),
        SCNVector3Make(0, -1 * sphereSize, 0),
        SCNVector3Make(0, sphereSize, 0),
        SCNVector3Make(0, 0, sphereSize),
        SCNVector3Make(0, 0, -1 * sphereSize),
        SCNVector3Make(0, 0, 0),
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
    
    
    class func randColor() -> UIColor {
        
        let randomRed:CGFloat = CGFloat(drand48()) - 50.0
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    
    class func newUnit() -> SCNGeometry {
        let unit = SCNSphere(radius: 2.0)
        unit.firstMaterial!.diffuse.contents = UIColor.grayColor()
        unit.firstMaterial!.specular.contents = UIColor.whiteColor()
        
        return unit
    }
    
    class func newCase() -> SCNGeometry {
        let unit = SCNBox(width: 12, height: 12, length: 12, chamferRadius: 1.0)
        
        unit.firstMaterial!.transparency = 0.4
        return unit
    }
    
    class func newNodeWithUnit(unit: SCNGeometry, pos: SCNVector3, parent: SCNNode?) -> SCNNode {
        let node = SCNNode(geometry: unit)
        node.position = pos
        parent?.addChildNode(node)
        return node
    }

    class func getPositionIndiceFromID(id: Int, origin: Int) -> (Float, Float) {
        let a : Float = origin / 6 == 0 ? Float(origin) : 11 - Float(origin)
        let b : Float = id / 6 == 0 ? Float(id) : 11 - Float(id)
        let c : Float = (origin / 6) == (id / 6) ? 0 : 15 * (origin / 6 == 1 ? 1 : -1)
        return (Float((b - a) * 15), Float(c))
    }
    
    class func moveUnit(old: SCNNode, new: SCNNode, id: Int, origin: Int) {
        let unit = old.childNodes[0]
        let p = new.childNodes.count
        
        let (x, y) = getPositionIndiceFromID(id, origin: origin)
        
        unit.removeFromParentNode()
        new.addChildNode(unit)
        unit.position = SCNVector3Make(unit.position.x + x, unit.position.y + y, unit.position.z)
        
        unit.runAction(SCNAction.moveTo(pos[p], duration: 1))
    }
    
    class func clearNode(unit: SCNNode) {
        for child in unit.childNodes {
            child.removeFromParentNode()
        }
    }
}