//
//  ViewController.swift
//  CardsUI
//
//  Created by Hamza Ghani on 7/27/17.
//  Copyright © 2017 dustr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    let data = ["Photos", "Twitter", "Instagram"]
    var i = 0
    var views = [UIView]()
    var animator: UIDynamicAnimator?
    var gravity: UIGravityBehavior?
    var snap: UISnapBehavior?
    var prevTouchPoint: CGPoint?
    var offset: CGFloat = 400
    var viewDragging = false
    var viewPinned = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        }

    
    @IBAction func addCard(_ sender: Any) {
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        
        
        animator?.addBehavior(gravity!)
        gravity?.magnitude = 1
        
        if i < 3 {
            if let view = addViewController(atOffset: offset, dataForVC: data[i]) {
                views.append(view)
                offset -= 75
                i += 1
            }
        }

        
        
        
    }
    
    
    func addViewController (atOffset offset: CGFloat, dataForVC: String?) -> UIView? {
        
        let frame = self.view.bounds.offsetBy(dx: 0, dy: self.view.bounds.size.height - offset)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let stackElementVC = sb.instantiateViewController(withIdentifier: "StackElement") as? StackViewController {
        if let view = stackElementVC.view {
            view.frame = frame
            view.layer.cornerRadius = 6
            view.layer.shadowOffset = CGSize(width: 2, height: 2)
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowRadius = 3
            view.layer.shadowOpacity = 0.5
            
            if let headStr = dataForVC {
                stackElementVC.headerString = headStr
            }
            
        
        
        self.addChildViewController(stackElementVC)
        self.view.addSubview(view)
        stackElementVC.didMove(toParentViewController: self)

    
        
        /*let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(gesture:)) )
        view.addGestureRecognizer(panGesture)
 */
            
       
        
        let collision = UICollisionBehavior(items: [view])
        collision.collisionDelegate = self
        animator?.addBehavior(collision)
        
        let boundary = view.frame.origin.y + view.frame.size.height
        var boundaryStart = CGPoint(x: 0, y: boundary)
        var boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: boundary)
        collision.addBoundary(withIdentifier: 1 as NSCopying, from: boundaryStart, to: boundaryEnd)
        
        boundaryStart = CGPoint(x: 0, y: 0)
        boundaryEnd = CGPoint(x:  self.view.bounds.size.width, y: 0)
        collision.addBoundary(withIdentifier: 2 as NSCopying, from: boundaryStart, to: boundaryEnd)

        
        gravity?.addItem(view)
        
        let itemBehavior = UIDynamicItemBehavior(items: [view])
        animator?.addBehavior(itemBehavior)
        
    }
    
        return view
            
        }
        
        
    
        return nil
    }
    
    
    func handlePan (gesture: UIPanGestureRecognizer) {
        
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

