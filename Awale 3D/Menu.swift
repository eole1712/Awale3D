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
    
    class func createMenuText(name: String, size: CGFloat) -> SCNNode {
        let text = SCNText()
        text.string = name
        text.font = UIFont(name: (text.font?.fontName)!, size: size)
        text.firstMaterial?.diffuse.contents = UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        
        return SCNNode(geometry: text)
    }
}