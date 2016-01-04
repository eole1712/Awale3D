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
        
        execScene(Menu.mainMenu(), funcName: "menuSceneTapped:")
        //execScene(Menu.gameOverMenu(map), funcName: "menuSceneTapped:")
        
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
                execScene(Menu.gameOverMenu(map), funcName: "menuSceneTapped:")
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
            } else if (node.childNodes.count == 0 && (node.geometry as? SCNText) == nil) {
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
                execScene(Menu.newGameScene(&map), funcName:  "gameSceneTapped:")
            } else if (text == "Head Menu") {
                execScene(Menu.mainMenu(), funcName: "menuSceneTapped:")
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
    
    func execScene(scene: SCNScene, funcName: Selector) {
        let scnView = self.view as! SCNView
        
        addCamera(scene)
        addLight(scene)
        scnView.scene = scene
        scnView.gestureRecognizers = [configureAction(funcName)]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
