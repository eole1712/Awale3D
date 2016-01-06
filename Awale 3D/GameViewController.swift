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
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
}

class GameViewController: UIViewController {
    
    var map = Map.init()
    var helper = Helper.init()
    
    let inGame = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scnView = self.view as! SCNView
        
        execScene(Menu.mainMenu(), tapActionFuncName: "menuSceneTapped:")
        
        //scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.whiteColor()
    }
    
    func gameSceneTapped(recognizer: UITapGestureRecognizer) {
        
        let scnView = self.view as! SCNView
        let location = recognizer.locationInView(scnView)
        let hitResults = scnView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults[0]
            let node = result.node
            
            if (map.endGame) {
                execScene(Menu.gameOverMenu(map), tapActionFuncName: "menuSceneTapped:")
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
                Unit.emptyNode(node)
            }
        }
    }
    
    func gameScenePressed(recognizer: UILongPressGestureRecognizer) {
        let scnView = self.view as! SCNView
        let location = recognizer.locationInView(scnView)
        let hitResults = scnView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            let result = hitResults[0]
            let node = result.node
            
            if (map.endGame) {
                return
            }
            
            let id = map.findNodeAction(map.map, child: node)
            if (node.childNodes.count > 0 && id < 12 && ((map.turn == 0 && id < 6) || (map.turn == 1 && id > 5))) {
                map.showPrediction(id, state: recognizer.state)
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
            
            switch text {
            case "New Game", "Replay":
                execScene(Menu.newGameScene(&map), tapActionFuncName:  "gameSceneTapped:", pressActionFuncName: "gameScenePressed:")
            case "Head Menu":
                execScene(Menu.mainMenu(), tapActionFuncName: "menuSceneTapped:")
            case "How to play":
                helper = Helper.init()
                execScene(Menu.sceneHowToPlay1(helper), tapActionFuncName: "helperSceneTapped:")
            case "About":
                execScene(Menu.aboutMenu(), tapActionFuncName: "aboutSceneTapped:")
            default: break
            }
        }
    }
    
    func aboutSceneTapped(recognizer: UITapGestureRecognizer) {
        execScene(Menu.mainMenu(), tapActionFuncName: "menuSceneTapped:")
    }
    
    
    func helperSceneTapped(recognizer: UITapGestureRecognizer) {
        
        let scnView = self.view as! SCNView
        let location = recognizer.locationInView(scnView)
        let hitResults = scnView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults[0]
            let node = result.node
            
            switch helper.scene {
            case 0:
                if (node == helper.map[0] && helper.clicked == false) {
                    helper.clicked = true
                    execScene(Menu.sceneHowToPlay1(helper), tapActionFuncName: "helperSceneTapped:")
                    helper.act()
                } else if (node.name == "Next") {
                    helper.prepareScene(1)
                    execScene(Menu.sceneHowToPlay2(helper), tapActionFuncName: "helperSceneTapped:")
                }
            case 1:
                if (node == helper.map[2] && helper.clicked == false) {
                    helper.clicked = true
                    execScene(Menu.sceneHowToPlay2(helper), tapActionFuncName: "helperSceneTapped:")
                    helper.act()
                } else if (node.name == "Next") {
                    helper.prepareScene(2)
                    execScene(Menu.sceneHowToPlay3(helper), tapActionFuncName: "helperSceneTapped:", pressActionFuncName: "helperScenePressed:")
                }
            case 2:
                if (node.name == "Next") {
                    helper.clicked = false
                    execScene(Menu.mainMenu(), tapActionFuncName: "menuSceneTapped:")
                }
            default: break
            }
        }
    }
    
    func helperScenePressed(recognizer: UITapGestureRecognizer) {
        
        let scnView = self.view as! SCNView
        let location = recognizer.locationInView(scnView)
        let hitResults = scnView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults[0]
            let node = result.node
            
            switch helper.scene {
            case 2:
                if (recognizer.state == .Began && node == helper.map[2] && helper.clicked == false) {
                    helper.clicked = true
                    execScene(Menu.sceneHowToPlay3(helper), tapActionFuncName: "helperSceneTapped:")
                    helper.act()
                }
            default: break
            }
        }
    }
    
    func execScene(scene: SCNScene, tapActionFuncName: Selector, pressActionFuncName: Selector = nil) {
        let scnView = self.view as! SCNView
        
        Action.addCamera(scene)
        Action.addLight(scene)
        scnView.scene = scene
        
        var gesture : [UIGestureRecognizer] = [Action.configureTapAction(self, funcName: tapActionFuncName)]
        if (pressActionFuncName != nil) {
            gesture += [Action.configurePressAction(self, funcName: pressActionFuncName)]
        }
        scnView.gestureRecognizers = gesture
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
