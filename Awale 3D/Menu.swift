//
//  Menu.swift
//  Awale 3D
//
//  Created by Grisha Ghukasyan on 04/01/2016.
//  Copyright © 2016 Grisha Ghukasyan. All rights reserved.
//

import SceneKit
import UIKit

class Menu {
    class func createMenuButton(name: String) -> (boxNode: SCNNode, textNode: SCNNode) {
        let text = SCNText()
        text.string = name
        text.font = UIFont(name: (text.font?.fontName)!, size: 5)
        text.firstMaterial?.diffuse.contents = UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        
        let box = SCNBox(width: 40, height: 8, length: 10, chamferRadius: 1.0)
        box.firstMaterial!.transparency = 0.4
        
        let boxNode = SCNNode(geometry: box)
        let textNode = SCNNode(geometry: text)
        boxNode.addChildNode(textNode)
        
        return (boxNode, textNode)
    }
    
    class func getSizeOfNode(node: SCNNode) -> (CGFloat, CGFloat) {
        
        var min = SCNVector3Zero
        var max = SCNVector3Zero
        node.getBoundingBoxMin(&min , max: &max)
        let w = CGFloat(max.x - min.x)
        let h = CGFloat(max.y - min.y)
        
        return (w, h)
    }
    
    class func createMenuText(name: String, size: CGFloat) -> SCNNode {
        let text = SCNText()
        text.string = name
        text.font = UIFont(name: (text.font?.fontName)!, size: size)
        text.firstMaterial?.diffuse.contents = UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        
        return SCNNode(geometry: text)
    }
    
    class func sceneHowToPlay1() -> SCNScene {
        let scene = SCNScene()
        
        let (w, h) = getSizeOfNode(scene.rootNode)
        
        print(w, h)
        
        let unit = Unit.newNodeWithUnit(Unit.newCase(), pos: SCNVector3(0, 0, 0), parent: nil)
        for j in 0..<4 {
            Unit.newNodeWithUnit(Unit.newUnit(), pos: Unit.pos[j], parent: unit)
        }
        
        return scene
    }
    
    class func mainMenu() -> SCNScene {
        let scene = SCNScene()
        
        let node = Menu.createMenuText("Awale 3D", size: 16)
        node.position = SCNVector3Make(-42, -17, 0)
        scene.rootNode.addChildNode(node)
        
        
        // MainMenu Animation
        let (w, h) = Menu.getSizeOfNode(node)
        
        let box = SCNNode(geometry: SCNBox(width: w, height: h, length: 20, chamferRadius: 1))
        box.position = SCNVector3(node.position.x + Float(w / 2), node.position.y + Float(h / 2), node.position.z)
        box.geometry?.firstMaterial?.transparency = 0
        
        node.position = SCNVector3Make(-42, -17, 0)
        
        var unit = Unit.newNodeWithUnit(Unit.newUnit(), pos: SCNVector3(w * 0.6, 0, 0), parent: nil)
        var action = SCNAction.rotateByAngle(360 * CGFloat(M_PI / 180.0), aroundAxis: SCNVector3(0.4, 1, 0), duration: 5)
        
        box.addChildNode(unit)
        box.runAction(SCNAction.repeatActionForever(action))
        
        unit = Unit.newNodeWithUnit(Unit.newUnit(), pos: SCNVector3(w * -0.6, 0, 0), parent: nil)
        action = SCNAction.rotateByAngle(360 * CGFloat(M_PI / 180.0), aroundAxis: SCNVector3(0.4, 1, 0), duration: 5)
        
        box.addChildNode(unit)
        box.runAction(SCNAction.repeatActionForever(action))
        scene.rootNode.addChildNode(box)
        // MainMenu Animation End
        
        
        var (boxNode, textNode) = Menu.createMenuButton("New Game")
        boxNode.position = SCNVector3Make(-7, -32, 0)
        textNode.position = SCNVector3Make(-12, -1.5, 12)
        scene.rootNode.addChildNode(boxNode)
        
        (boxNode, textNode) = Menu.createMenuButton("About")
        boxNode.position = SCNVector3Make(-7, -42, 0)
        textNode.position = SCNVector3Make(-7, -0.3, 12)
        scene.rootNode.addChildNode(boxNode)
        
        return scene
    }
    
    class func gameOverMenu(map: Map) -> SCNScene {
        let scene = SCNScene()
        
        var node = Menu.createMenuText("Game Over !", size: 8)
        node.position = SCNVector3Make(-30, -10, 0)
        scene.rootNode.addChildNode(node)
        
        let text = "Player " + (map.players[0] >= map.players[1] ? "1" : "2") + " won !"
        node = Menu.createMenuText(text, size: 5)
        node.position = SCNVector3Make(-23, -20, 0)
        scene.rootNode.addChildNode(node)
        
        
        var (boxNode, textNode) = Menu.createMenuButton("Replay")
        boxNode.position = SCNVector3Make(-7, -32, 0)
        textNode.position = SCNVector3Make(-8, -1, 12)
        scene.rootNode.addChildNode(boxNode)
        
        (boxNode, textNode) = Menu.createMenuButton("Head Menu")
        boxNode.position = SCNVector3Make(-7, -42, 0)
        textNode.position = SCNVector3Make(-13, -0.3, 12)
        scene.rootNode.addChildNode(boxNode)
        
        return scene
    }
    
    class func newGameScene(inout map: Map) -> SCNScene {
        map = Map.init()
        
        let scene = SCNScene()
        
        scene.rootNode.addChildNode(map.map)
        
        var textNode = SCNNode(geometry: map.player2)
        textNode.position = SCNVector3Make(40, -1, 0)
        textNode.rotation = SCNVector4(0, 0, 1, CGFloat(M_PI))
        scene.rootNode.addChildNode(textNode)
        
        textNode = SCNNode(geometry: map.player1)
        textNode.position = SCNVector3Make(-55, -45, 0)
        scene.rootNode.addChildNode(textNode)
        
        return scene
    }
    
}