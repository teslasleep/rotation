//
//  ViewController.swift
//  Rotation
//
//  Created by Chernoev Andrew on 19/05/2019.
//  Copyright © 2019 no_team. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var notRotatingView: UIView?
    @IBOutlet var portraitView: UIView?
    @IBOutlet var landscapeView: UIView?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        portraitView?.center = CGPoint(x: view.bounds.midX,
                                         y: view.bounds.midY)
        landscapeView?.center = CGPoint(x: view.bounds.midX,
                                        y: view.bounds.midY)
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] (context) in
            guard let transformedView = self?.portraitView else {
                return
            }

            let deltaTransform = coordinator.targetTransform
            let deltaAngle: Float = atan2f(Float(deltaTransform.b),
                                           Float(deltaTransform.a))
            if var currentRotation = transformedView.layer.value(forKeyPath: "transform.rotation.z") as? Double {
                currentRotation += -1 * Double(deltaAngle) + 0.0001;
                transformedView.layer.setValue(currentRotation,
                                                     forKeyPath: "transform.rotation.z")
            }
        }) { [weak self] (context) in
            guard let transformedView = self?.portraitView else {
                return
            }
            var currentTransform = transformedView.transform
            currentTransform.a = round(currentTransform.a)
            currentTransform.b = round(currentTransform.b)
            currentTransform.c = round(currentTransform.c)
            currentTransform.d = round(currentTransform.d)
            transformedView.transform = currentTransform
        }
    }
    
    
    @IBAction func swap(_ sender: Any?) {
        
        super.view.sizeToFit()
        super.view.setNeedsLayout()
        super.view.setNeedsDisplay()
        super.view.layoutIfNeeded()
        super.view.layoutSubviews()
        
        
        view.sizeToFit()
        view.setNeedsLayout()
        view.setNeedsDisplay()
        view.layoutIfNeeded()
        view.layoutSubviews()
        
        
        if portraitView?.isHidden == true {
            portraitView?.isHidden = false
            landscapeView?.isHidden = true
        } else {
            portraitView?.isHidden = true
            landscapeView?.isHidden = false
        }
    }
    
    @IBAction func close(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
}


class ChildPortraitViewController: UIViewController {
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

class ChildLandscapeViewController: UIViewController {
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}
