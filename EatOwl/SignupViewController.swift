//
//  SignupViewController.swift
//  EatOwl
//
//  Created by Daniel Li on 7/10/15.
//  Copyright (c) 2015 PRHSRobotics. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameText.delegate = self
        passwordText.delegate = self
        confirmPasswordText.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedOutside(sender: UITapGestureRecognizer) {
        usernameText.resignFirstResponder()
        passwordText.resignFirstResponder()
        confirmPasswordText.resignFirstResponder()
        
    }
    @IBAction func loginPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func signupTapped(sender : UIButton) {
        var username:NSString = usernameText.text as NSString
        var password:NSString = passwordText.text as NSString
        var confirmPassword:NSString = confirmPasswordText.text as NSString
        
        if (username.isEqualToString("") || password.isEqualToString("")) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up failed!"
            alertView.message = "Please enter username and password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else if (!password.isEqual(confirmPassword)) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign up failed!"
            alertView.message = "Passwords doesn't match"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else {
            
            var post:NSString = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string: "\(domain)/register_process.php")!
            
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String( postData.length )
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var responseError: NSError?
            var response: NSURLResponse?
            
            if var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&responseError) {
                let res = response as! NSHTTPURLResponse!
                
                NSLog("Response code: %ld", res.statusCode)
                
                if (res.statusCode >= 200 && res.statusCode < 300) {
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setObject(password, forKey: "PASSWORD")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign up failed!"
                    alertView.message = "Server error"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }  else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in failed!"
                alertView.message = "Connection failed, check your internet connection"
                if let error = responseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }
        
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
