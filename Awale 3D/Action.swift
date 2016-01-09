//
//  Actions.swift
//  Awale 3D
//
//  Created by Grisha Ghukasyan on 06/01/2016.
//  Copyright © 2016 Grisha Ghukasyan. All rights reserved.
//

import UIKit
import SceneKit

class Action {
    class func configureTapAction(target: AnyObject, funcName: Selector) -> UITapGestureRecognizer {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.addTarget(target, action: funcName)
        return tapRecognizer
    }
    
    class func configurePressAction(target: AnyObject, funcName: Selector) -> UILongPressGestureRecognizer {
        let pressRecognizer = UILongPressGestureRecognizer()
        pressRecognizer.addTarget(target, action: funcName)
        return pressRecognizer
    }
    
    class func addCamera(scene: SCNScene) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(-8, -23, 55)
        scene.rootNode.addChildNode(cameraNode)
        
        let ambientLight = SCNLight()
        ambientLight.type = SCNLightTypeAmbient
        ambientLight.color = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        cameraNode.light = ambientLight
    }
    
    class func addLight(scene: SCNScene) {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLightTypeSpot
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(-10, -60, 200)
        scene.rootNode.addChildNode(omniLightNode)
    }
}