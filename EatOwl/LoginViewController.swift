//
//  LoginViewController.swift
//  EatOwl
//
//  Created by Daniel Li on 7/10/15.
//  Copyright (c) 2015 PRHSRobotics. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passText: UITextField!
    
    let incorrectUserAndPassURL = NSURL(string: "\(domain)/login_user.php?error=Incorrect+username+and%2For+password.")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userText.delegate = self
        passText.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedOutside(sender: UITapGestureRecognizer) {
        userText.resignFirstResponder()
        passText.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelToLogInViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func enterPressed() {
        var username:NSString = userText.text
        var password:NSString = passText.text
        userText.resignFirstResponder()
        passText.resignFirstResponder()
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in failed!"
            alertView.message = "Please enter a valid username and password."
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else {
            var post:NSString = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string:"\(domain)/login_process.php")!
            
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String(postData.length)
            
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
                    println("NSURL response URL is:")
                    println(response!.URL!)
                    if response!.URL!.isEqual(incorrectUserAndPassURL) {
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in failed!"
                        alertView.message = "Incorrect username and/or password."
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        println("YAYYAYAYAYAYAYAYA")
                    }
                    else {
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setObject(password, forKey: "PASSWORD")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in failed!"
                    alertView.message = "A server error occurred."
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in failed!"
                alertView.message = "The connection to the server failed. Please check your internet connection."
                if let error = responseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }

                /*
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setObject(username, forKey: "USERNAME")
        prefs.setObject(password, forKey: "PASSWORD")
        prefs.setInteger(1, forKey: "ISLOGGEDIN")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        */
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
