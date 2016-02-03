//
//  NoAnimationSegue.swift
//  EatOwl
//
//  Created by Daniel Li on 7/10/15.
//  Copyright (c) 2015 PRHSRobotics. All rights reserved.
//

import UIKit

/// Move to the next screen without an animation.
class NoAnimationSegue: UIStoryboardSegue {
    
    override func perform() {
        let source = sourceViewController as! UIViewController
        if let navigation = source.navigationController {
            navigation.presentViewController(destinationViewController as! UIViewController, animated: false, completion: nil)
        }
    }
    
}