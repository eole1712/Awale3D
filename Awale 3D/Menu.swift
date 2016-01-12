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
    
    class func createMenuButton(name: String, w: CGFloat = 40, h: CGFloat = 8) -> (boxNode: SCNNode, textNode: SCNNode) {
        let text = SCNText()
        text.string = name
        text.font = UIFont(name: (text.font?.fontName)!, size: 5)
        text.firstMaterial?.diffuse.contents = UIColor(colorLiteralRed: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        let box = SCNBox(width: w, height: h, length: 10, chamferRadius: 1.0)
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
        text.firstMaterial?.diffuse.contents = UIColor(colorLiteralRed: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        return SCNNode(geometry: text)
    }
    
    class func mainMenu(night: Bool) -> SCNScene {
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
        
        var unit = Unit.newNodeWithUnit(Unit.newUnit(night), pos: SCNVector3(w * 0.6, 0, 0), parent: nil)
        var action = SCNAction.rotateByAngle(360 * CGFloat(M_PI / 180.0), aroundAxis: SCNVector3(0.4, 1, 0), duration: 5)
        
        box.addChildNode(unit)
        box.runAction(SCNAction.repeatActionForever(action))
        
        unit = Unit.newNodeWithUnit(Unit.newUnit(night), pos: SCNVector3(w * -0.6, 0, 0), parent: nil)
        action = SCNAction.rotateByAngle(360 * CGFloat(M_PI / 180.0), aroundAxis: SCNVector3(0.4, 1, 0), duration: 5)
        
        box.addChildNode(unit)
        box.runAction(SCNAction.repeatActionForever(action))
        scene.rootNode.addChildNode(box)
        // MainMenu Animation End
        
        
        var (boxNode, textNode) = Menu.createMenuButton("New Game")
        boxNode.position = SCNVector3Make(-7, -24, 0)
        textNode.position = SCNVector3Make(-13, -2.5, 12)
        scene.rootNode.addChildNode(boxNode)
        
        (boxNode, textNode) = Menu.createMenuButton("How to play")
        boxNode.position = SCNVector3Make(-7, -34, 0)
        textNode.position = SCNVector3Make(-14, -1, 12)
        scene.rootNode.addChildNode(boxNode)
        
        (boxNode, textNode) = Menu.createMenuButton("About")
        boxNode.position = SCNVector3Make(-7, -44, 0)
        textNode.position = SCNVector3Make(-7, 0.5, 12)
        scene.rootNode.addChildNode(boxNode)
        
        
        return scene
    }
    
    class func gameOverMenu(map: Map, inout player : [AI?]) -> SCNScene {
        let scene = SCNScene()

        player[0] = nil
        player[1] = nil
        
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
    
    class func gameScene(inout map: Map, inout player: [AI?], mode: Int, night: Bool) -> SCNScene {
        map = Map.init(night: night)
        
        if (mode == 2) {
            player[0] = AI.init(map: map, turn: 0)
        }
        
        if (mode >= 1) {
            player[1] = AI.init(map: map, turn: 1)
        }
        
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
    
    class func newGameScene() -> SCNScene {

        let scene = SCNScene()

        var (boxNode, textNode) = Menu.createMenuButton("Player vs AI")
        boxNode.position = SCNVector3Make(-7, -12, 0)
        textNode.position = SCNVector3Make(-14, -4, 12)
        
        scene.rootNode.addChildNode(boxNode)
        
        (boxNode, textNode) = Menu.createMenuButton("Two players")
        boxNode.position = SCNVector3Make(-7, -22, 0)
        textNode.position = SCNVector3Make(-14, -2.5, 12)
        scene.rootNode.addChildNode(boxNode)

        (boxNode, textNode) = Menu.createMenuButton("Two AI")
        boxNode.position = SCNVector3Make(-7, -32, 0)
        textNode.position = SCNVector3Make(-8, -1.25, 12)
        scene.rootNode.addChildNode(boxNode)

        (boxNode, textNode) = Menu.createMenuButton("Return")
        boxNode.position = SCNVector3Make(-7, -42, 0)
        textNode.position = SCNVector3Make(-8, -0, 12)
        scene.rootNode.addChildNode(boxNode)
        
        return scene
    }
    
    class func sceneHowToPlay0(helper: Helper) -> SCNScene {
        let scene = SCNScene()
        
        scene.rootNode.addChildNode(helper.node)
        
        var textNode = Menu.createMenuText("The game board consists of two halves,", size: 4)
        textNode.position = SCNVector3Make(-60, -45, 0)
        scene.rootNode.addChildNode(textNode)
        textNode = Menu.createMenuText("with six box in each half !", size: 4)
        textNode.position = SCNVector3Make(-47, -50, 0)
        scene.rootNode.addChildNode(textNode)
        if (helper.clicked) {
            let (boxNode, txtNode) = Menu.createMenuButton("Next", w: 20)
            boxNode.position = SCNVector3Make(30, -45, 0)
            txtNode.position = SCNVector3Make(-11, 0.4, 12)
            boxNode.name = "Next"
            scene.rootNode.addChildNode(boxNode)
        }
        return scene
    }
    
    class func sceneHowToPlay1(helper: Helper) -> SCNScene {
        let scene = SCNScene()
        
        scene.rootNode.addChildNode(helper.node)
        
        if (helper.clicked) {
            let (boxNode, txtNode) = Menu.createMenuButton("Next", w: 20)
            boxNode.position = SCNVector3Make(-10, -45, 0)
            txtNode.position = SCNVector3Make(-5, 0.4, 12)
            boxNode.name = "Next"
            scene.rootNode.addChildNode(boxNode)
        } else {
            var textNode = Menu.createMenuText("Tap on a filled box to distribute its spheres", size: 4)
            textNode.position = SCNVector3Make(-50, -45, 0)
            scene.rootNode.addChildNode(textNode)
            textNode = Menu.createMenuText("in the following boxes !", size: 4)
            textNode.position = SCNVector3Make(-32, -50, 0)
            scene.rootNode.addChildNode(textNode)
        }
        return scene
    }
    
    class func sceneHowToPlay2(helper: Helper) -> SCNScene {
        let scene = SCNScene()
        
        scene.rootNode.addChildNode(helper.node)
        
        if (helper.clicked) {
            let (boxNode, txtNode) = Menu.createMenuButton("Next", w: 20)
            boxNode.position = SCNVector3Make(-10, -45, 0)
            txtNode.position = SCNVector3Make(-5, 0.4, 12)
            boxNode.name = "Next"
            scene.rootNode.addChildNode(boxNode)
        } else {
            var textNode = Menu.createMenuText("If your last distributed sphere falls into an enemy box", size: 4)
            textNode.position = SCNVector3Make(-58, -45, 0)
            scene.rootNode.addChildNode(textNode)
            textNode = Menu.createMenuText("containing only one or two spheres, you eat them all !", size: 4)
            textNode.position = SCNVector3Make(-58, -50, 0)
            scene.rootNode.addChildNode(textNode)
        }
        return scene
    }
    
    class func sceneHowToPlay3(helper: Helper) -> SCNScene {
        let scene = SCNScene()
        
        scene.rootNode.addChildNode(helper.node)
        
        if (helper.clicked) {
            let (boxNode, txtNode) = Menu.createMenuButton("Next", w: 20)
            boxNode.position = SCNVector3Make(-10, -45, 0)
            txtNode.position = SCNVector3Make(-5, 0.4, 12)
            boxNode.name = "Next"
            scene.rootNode.addChildNode(boxNode)
        } else {
            var textNode = Menu.createMenuText("When this happens,", size: 4)
            textNode.position = SCNVector3Make(-28, -45, 0)
            scene.rootNode.addChildNode(textNode)
            textNode = Menu.createMenuText("the preceding ennemy box is also examined !", size: 4)
            textNode.position = SCNVector3Make(-50, -50, 0)
            scene.rootNode.addChildNode(textNode)
        }
        return scene
    }
    
    class func sceneHowToPlay4(helper: Helper) -> SCNScene {
        let scene = SCNScene()
        
        scene.rootNode.addChildNode(helper.node)
        
        if (helper.clicked) {
            let (boxNode, txtNode) = Menu.createMenuButton("Next", w: 20)
            boxNode.position = SCNVector3Make(-10, -45, 0)
            txtNode.position = SCNVector3Make(-5, 0.4, 12)
            boxNode.name = "Next"
            scene.rootNode.addChildNode(boxNode)
        } else {
            var textNode = Menu.createMenuText("Press on a box to find out which enemy spheres", size: 4)
            textNode.position = SCNVector3Make(-53, -45, 0)
            scene.rootNode.addChildNode(textNode)
            textNode = Menu.createMenuText("he can eat !", size: 4)
            textNode.position = SCNVector3Make(-20, -50, 0)
            scene.rootNode.addChildNode(textNode)
        }
        return scene
    }
    
    class func sceneHowToPlay5(helper: Helper) -> SCNScene {
        let scene = SCNScene()
        
        scene.rootNode.addChildNode(helper.node)
        
        if (helper.clicked) {
            let (boxNode, txtNode) = Menu.createMenuButton("Next", w: 20)
            boxNode.position = SCNVector3Make(-10, -45, 0)
            txtNode.position = SCNVector3Make(-5, 0.4, 12)
            boxNode.name = "Next"
            scene.rootNode.addChildNode(boxNode)
        } else {
            var textNode = Menu.createMenuText("If your opponent has no more spheres in its boxes,", size: 4)
            textNode.position = SCNVector3Make(-53, -45, 0)
            scene.rootNode.addChildNode(textNode)
            textNode = Menu.createMenuText("you must feed him.", size: 4)
            textNode.position = SCNVector3Make(-20, -50, 0)
            scene.rootNode.addChildNode(textNode)
        }
        return scene
    }
    
    class func sceneHowToPlay6(helper: Helper) -> SCNScene {
        let scene = SCNScene()
        
        scene.rootNode.addChildNode(helper.node)
        
        if (helper.clicked) {
            let (boxNode, txtNode) = Menu.createMenuButton("End", w: 20)
            boxNode.position = SCNVector3Make(30, -45, 0)
            txtNode.position = SCNVector3Make(-10, 0.4, 12)
            boxNode.name = "Next"
            scene.rootNode.addChildNode(boxNode)
        }
        
        var textNode = Menu.createMenuText("If you cannot feed him or if a player has", size: 4)
        textNode.position = SCNVector3Make(-60, -45, 0)
        scene.rootNode.addChildNode(textNode)
        textNode = Menu.createMenuText("eaten at least 25 spheres, the game ends.", size: 4)
        textNode.position = SCNVector3Make(-60, -50, 0)
        scene.rootNode.addChildNode(textNode)
        return scene
    }
    
    class func aboutMenu() -> SCNScene {
        let scene = SCNScene()
        
        var textNode = Menu.createMenuText("Created by : Grisha Ghukasyan", size: 4)
        textNode.position = SCNVector3Make(-50, -40, 0)
        scene.rootNode.addChildNode(textNode)
        
        textNode = Menu.createMenuText("Contact : contact[at]awale3d.com", size: 4)
        textNode.position = SCNVector3Make(-50, -45, 0)
        scene.rootNode.addChildNode(textNode)
        
        textNode = Menu.createMenuText("http://www.Awale3D.com", size: 4)
        textNode.position = SCNVector3Make(-50, -50, 0)
        scene.rootNode.addChildNode(textNode)
        
        return scene
    }
}