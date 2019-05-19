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
    
    private enum Constants {
        static let rotationAngle = -90.0 / 180.0 * CGFloat.pi
        
        static func translationX(view: UIView) -> CGFloat {
            return view.frame.size.width / 2.0
        }
        
        static func translationY(view: UIView) -> CGFloat {
            return view.frame.size.height / 2.0
        }
    }
    
    fileprivate func transformView() {
        if let landscapeView = landscapeView {
            landscapeView.transform = CGAffineTransform(translationX: Constants.translationX(view: landscapeView),
                                                        y: Constants.translationY(view: landscapeView))
            landscapeView.transform = CGAffineTransform(rotationAngle: Constants.rotationAngle)
        }
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
        
        func transition(destination: UIView, context: UIViewControllerTransitionCoordinatorContext) {
            let deltaTransform = coordinator.targetTransform
            let deltaAngle = atan2(Double(deltaTransform.b),
                                   Double(deltaTransform.a))
            if var currentRotation = destination.layer.value(forKeyPath: "transform.rotation.z") as? Double {
                currentRotation += -1 * deltaAngle + 0.0001;
                destination.layer.setValue(currentRotation,
                                               forKeyPath: "transform.rotation.z")
            }
        }
        
        func transitionComplete(destination: UIView, context: UIViewControllerTransitionCoordinatorContext) {
            var currentTransform = destination.transform
            currentTransform.a = round(currentTransform.a)
            currentTransform.b = round(currentTransform.b)
            currentTransform.c = round(currentTransform.c)
            currentTransform.d = round(currentTransform.d)
            destination.transform = currentTransform
        }
        
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            if let portraitView = self?.portraitView {
                transition(destination: portraitView, context: context)
            }
            
            if let landscapeView = self?.landscapeView {
                transition(destination: landscapeView, context: context)
            }
        }) { [weak self] (context) in
            if let portraitView = self?.portraitView {
                transitionComplete(destination: portraitView, context: context)
            }
            
            if let landscapeView = self?.landscapeView {
                transitionComplete(destination: landscapeView, context: context)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        transformView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func swap(_ sender: Any?) {
//        if portraitView?.isHidden == true {
//            portraitView?.isHidden = false
//            landscapeView?.isHidden = true
//        } else {
//            portraitView?.isHidden = true
//            landscapeView?.isHidden = false
//        }
    }
    
    @IBAction func close(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
}


class ChildPortraitViewController: ContentableViewController {
   
}

class ChildLandscapeViewController: ContentableViewController {
    
}


class ContentableViewController: UIViewController {
    @IBOutlet var content: UIView?

}
