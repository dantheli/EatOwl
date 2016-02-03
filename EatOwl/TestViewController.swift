//
//  TestViewController.swift
//  EatOwl
//
//  Created by Daniel Li on 7/11/15.
//  Copyright (c) 2015 PRHSRobotics. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            self.username.text = prefs.valueForKey("USERNAME") as? String
        self.password.text = prefs.valueForKey("PASSWORD") as? String

    }
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var password: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
