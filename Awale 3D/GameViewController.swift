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
    
    var map : Map = Map.init(night: true)
    var helper : Helper = Helper.init(night: true)
    
    var player : [AI?] = [nil, nil]
    
    let inGame = false
    
    let night = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scnView = self.view as! SCNView
        
        execScene(Menu.mainMenu(night), tapActionFuncName: "menuSceneTapped:")
        
        scnView.autoenablesDefaultLighting = false
        scnView.backgroundColor = (night ? UIColor.blackColor() : UIColor.whiteColor())
    }
    
    func doAIAction() {
        
        let scnView = self.view as! SCNView
        
        if (player[map.turn] != nil && map.endGame == false) {
            if let act = player[map.turn]!.nextAction() {
                let time = map.doAction(act)
                
                if (player[(map.turn == 0 ? 1 : 0)] != nil) {
                    scnView.scene?.rootNode.runAction(SCNAction.waitForDuration(time + 0.2), completionHandler: doAIAction)
                }
            } else {
                map.endGame = true
            }
            if (map.endGame) {
                map.endGameAction()
            }
        }
    }
    
    func gameSceneTapped(recognizer: UITapGestureRecognizer) {
        
        let scnView = self.view as! SCNView
        let location = recognizer.locationInView(scnView)
        let hitResults = scnView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults[0]
            let node = result.node
            
            if (map.endGame) {
                execScene(Menu.gameOverMenu(map, player: &player), tapActionFuncName: "menuSceneTapped:")
                map.endGame = false
                return
            }
            
            if let id = map.findNodeAction(map.map, child: node) {
                
                if (map._map[id].0 == 0) {
                    Unit.emptyNode(node)
                    return
                }
                if ((player[0] == nil && map.turn == 0 && id < 6) || (player[1] == nil && map.turn == 1 && id > 5)) {
                    let time = map.doAction(id)
                    
                    //AI TIME
                    if (map.endGame == false && player[1] != nil) {
                        scnView.scene?.rootNode.runAction(SCNAction.waitForDuration(time + 0.2), completionHandler: doAIAction)
                    }
                    //AI END
                }
                if (map.endGame) {
                    map.endGameAction()
                }
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
            
            if let id = map.findNodeAction(map.map, child: node) {
                if (((map.turn == 0 && id < 6 && player[0] == nil) || (map.turn == 1 && id > 5 && player[1] == nil))) {
                    map.showPrediction(id, state: recognizer.state)
                }
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
                execScene(Menu.newGameScene(), tapActionFuncName: "menuSceneTapped:")
            case "Head Menu", "Return":
                execScene(Menu.mainMenu(night), tapActionFuncName: "menuSceneTapped:")
            case "How to play":
                helper = Helper.init(night: night)
                execScene(Menu.sceneHowToPlay0(helper), tapActionFuncName: "helperSceneTapped:")
            case "About":
                execScene(Menu.aboutMenu(), tapActionFuncName: "aboutSceneTapped:")
            case "Player vs AI":
                execScene(Menu.gameScene(&map, player: &player, mode: 1, night: night), tapActionFuncName: "gameSceneTapped:", pressActionFuncName: "gameScenePressed:")
            case "Two players":
                execScene(Menu.gameScene(&map, player: &player, mode: 0, night: night), tapActionFuncName: "gameSceneTapped:", pressActionFuncName: "gameScenePressed:")
            case "Two AI":
                execScene(Menu.gameScene(&map, player: &player, mode: 2, night: night), tapActionFuncName: "gameSceneTapped:", pressActionFuncName: "gameScenePressed:")
                scnView.scene?.rootNode.runAction(SCNAction.waitForDuration(1), completionHandler: doAIAction)
            default: break
            }
        }
    }
    
    func aboutSceneTapped(recognizer: UITapGestureRecognizer) {
        execScene(Menu.mainMenu(night), tapActionFuncName: "menuSceneTapped:")
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
                if (node.name == "Next") {
                    helper.prepareScene(1)
                    execScene(Menu.sceneHowToPlay1(helper), tapActionFuncName: "helperSceneTapped:")
                }
            case 1:
                if (node == helper.map[0] && helper.clicked == false) {
                    helper.clicked = true
                    execScene(Menu.sceneHowToPlay1(helper), tapActionFuncName: "helperSceneTapped:")
                    helper.act()
                } else if (node.name == "Next") {
                    helper.prepareScene(2)
                    execScene(Menu.sceneHowToPlay2(helper), tapActionFuncName: "helperSceneTapped:")
                }
            case 2:
                if (node == helper.map[2] && helper.clicked == false) {
                    helper.clicked = true
                    execScene(Menu.sceneHowToPlay2(helper), tapActionFuncName: "helperSceneTapped:")
                    helper.act()
                } else if (node.name == "Next") {
                    helper.prepareScene(3)
                    execScene(Menu.sceneHowToPlay3(helper), tapActionFuncName: "helperSceneTapped:", pressActionFuncName: "helperScenePressed:")
                }
            case 3:
                if (node == helper.map[1] && helper.clicked == false) {
                    helper.clicked = true
                    execScene(Menu.sceneHowToPlay3(helper), tapActionFuncName: "helperSceneTapped:")
                    helper.act()
                } else if (node.name == "Next") {
                    helper.prepareScene(4)
                    execScene(Menu.sceneHowToPlay4(helper), tapActionFuncName: "helperSceneTapped:", pressActionFuncName: "helperScenePressed:")
                }
            case 4:
                if (node.name == "Next") {
                    helper.prepareScene(5)
                    helper.clicked = false
                    execScene(Menu.sceneHowToPlay5(helper), tapActionFuncName: "helperSceneTapped:")
                }
            case 5:
                if (node == helper.map[1] && helper.clicked == false) {
                    helper.clicked = true
                    execScene(Menu.sceneHowToPlay5(helper), tapActionFuncName: "helperSceneTapped:")
                    helper.act()
                } else if (node.name == "Next") {
                    helper.prepareScene(6)
                    execScene(Menu.sceneHowToPlay6(helper), tapActionFuncName: "helperSceneTapped:")
                }
            case 6:
                if (node.name == "Next") {
                    execScene(Menu.mainMenu(night), tapActionFuncName: "menuSceneTapped:")
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
            case 4:
                if (recognizer.state == .Began && node == helper.map[2] && helper.clicked == false) {
                    helper.clicked = true
                    execScene(Menu.sceneHowToPlay4(helper), tapActionFuncName: "helperSceneTapped:")
                    helper.act()
                }
            default: break
            }
        }
    }
    
    func execScene(scene: SCNScene, tapActionFuncName: Selector, pressActionFuncName: Selector = nil) {
        let scnView = self.view as! SCNView
        
        Action.addCamera(scene, night: night)
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
