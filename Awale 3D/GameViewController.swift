//
//  GameViewController.swift
//  Ebola3D
//
//  Created by Grisha Ghukasyan on 02/01/2016.
//  Copyright (c) 2016 Grisha Ghukasyan. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import CoreGraphics


func CGRand() -> CGFloat {
    let a = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    return a
}

class GameViewController: UIViewController {
    
    var map = Map.init()
    let inGame = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scnView = self.view as! SCNView
        
        mainMenu()
        
        //scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.whiteColor()
    }
    
    func configureAction(funcName: Selector) -> UITapGestureRecognizer {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.addTarget(self, action: funcName)
        return tapRecognizer
    }
    
    func gameSceneTapped(recognizer: UITapGestureRecognizer) {
        
        let scnView = self.view as! SCNView
        
        let location = recognizer.locationInView(scnView)
        
        let hitResults = scnView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults[0]
            let node = result.node
            
            if (map.endGame) {
                gameOverMenu()
                map.endGame = false
                return
            }
            
            let id = map.findNodeAction(map.map, child: node)
            
            if (node.childNodes.count > 0 && id < 12 && ((map.turn == 0 && id < 6) || (map.turn == 1 && id > 5))) {
                map.doAction(id)
                if (map.endGame) {
                    for i in 0..<12 {
                        map._map[i].1.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(CGRand(), y: CGRand(), z: CGRand(), duration: 0.5)))
                    }
                }
            }
            else if (node.childNodes.count == 0 && (node.geometry as? SCNText) == nil) {
                node.runAction(SCNAction.repeatAction(SCNAction.rotateByX(CGRand(), y: CGRand(), z: CGRand(), duration: 0.5), count: 2))
            }
        }
    }
    
    func menuSceneTapped(recognizer: UITapGestureRecognizer) {
        
        let scnView = self.view as! SCNView
        
        let location = recognizer.locationInView(scnView)
        
        let hitResults = scnView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults[0]
            var node = result.node
            
            while (node.childNodes.count > 0) {
                node = node.childNodes[0]
            }
            var text : String = String("")
            
            let a : AnyObject? = (node.geometry as? SCNText)?.string
            
            if (a != nil) {
                text = a as! String
            }
            
            if (text == "New Game" || text == "Replay") {
                startAGame()
            } else if (text == "Head Menu") {
                mainMenu()
            }
        }
    }
    
    func addCamera(scene: SCNScene) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(-8, -23, 55)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    func addLight(scene: SCNScene) {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLightTypeSpot
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(-10, -60, 200)
        scene.rootNode.addChildNode(omniLightNode)
    }
    
    func startAGame() {
        map = Map.init()
        let scnView = self.view as! SCNView
        
        let scene = SCNScene()
        
        scene.rootNode.addChildNode(map.map)
        
        var textNode = SCNNode(geometry: map.player2)
        textNode.position = SCNVector3Make(20, -5, 0)
        scene.rootNode.addChildNode(textNode)
        
        textNode = SCNNode(geometry: map.player1)
        textNode.position = SCNVector3Make(-55, -45, 0)
        scene.rootNode.addChildNode(textNode)
        
        addCamera(scene)
        addLight(scene)
        scnView.scene = scene
        scnView.gestureRecognizers = [configureAction("gameSceneTapped:")]
    }
    
    func mainMenu() {
        let scnView = self.view as! SCNView
        let scene = SCNScene()
        
        let node = Menu.createMenuText("Awale 3D", size: 16)
        node.position = SCNVector3Make(-42, -17, 0)
        scene.rootNode.addChildNode(node)
        
        var min = SCNVector3Zero
        var max = SCNVector3Zero
        node.getBoundingBoxMin(&min , max: &max)
        let w = CGFloat(max.x - min.x)
        let h = CGFloat(max.y - min.y)
        
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
        
        var (boxNode, textNode) = Menu.createMenuButton("New Game")
        
        
        boxNode.position = SCNVector3Make(-7, -32, 0)
        textNode.position = SCNVector3Make(-12, -1.5, 12)
        
        scene.rootNode.addChildNode(boxNode)
        
        (boxNode, textNode) = Menu.createMenuButton("About")
        
        boxNode.position = SCNVector3Make(-7, -42, 0)
        textNode.position = SCNVector3Make(-7, -0.3, 12)
        
        scene.rootNode.addChildNode(boxNode)
        
        addCamera(scene)
        addLight(scene)
        scnView.scene = scene
        scnView.gestureRecognizers = [configureAction("menuSceneTapped:")]
    }
    
    func gameOverMenu() {
        let scnView = self.view as! SCNView
        
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
        
        addCamera(scene)
        addLight(scene)
        scnView.scene = scene
        scnView.gestureRecognizers = [configureAction("menuSceneTapped:")]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
