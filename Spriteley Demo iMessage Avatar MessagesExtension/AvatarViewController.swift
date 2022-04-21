//
//  AvatarViewController.swift
//  Spriteley Demo iMessage Avatar MessagesExtension
//
//  Created by Spriteley on 4/20/22.
//

import Foundation
import UIKit
import SceneKit

class AvatarViewController:UIViewController{

    var sceneView:SCNView!
    
    weak var messageDelegate:AvatarViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = SCNView(frame: view.bounds)
        view.addSubview(sceneView)
        sceneView.scene = AvatarScene()
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = .black
        sceneView.autoenablesDefaultLighting = true
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        
        sceneView.showsStatistics = true
        
        let doubleTapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sendAvatar))
        doubleTapGesture.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(doubleTapGesture)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func sendAvatar(){
        print("sending the avatar")
        messageDelegate?.sendAvatar()
    }
    
}

protocol AvatarViewControllerDelegate:AnyObject {
    func sendAvatar()
}
