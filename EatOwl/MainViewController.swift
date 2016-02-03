//
//  ViewController.swift
//  EatOwl
//
//  Created by Daniel Li on 7/10/15.
//  Copyright (c) 2015 PRHSRobotics. All rights reserved.
//
var domain: String = "http://104.131.48.234/foodfinderpillow/FoodPillowServer"
import UIKit
import CoreLocation

class MainViewController: UIViewController, UIWebViewDelegate, CLLocationManagerDelegate {
    
    var manager:CLLocationManager!
    var location: CLLocation!
    let incorrectUserAndPassURL = NSURL(string: "\(domain)/login_user.php?error=Incorrect+username+and%2For+password.")
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var loggedInServer: Bool = true
    var lastURL:NSURL? = nil
    let loginURL = NSURL(string: "\(domain)/login_user.php")
    let trainURL = NSURL(string: "\(domain)/user_train.php")
    
    @IBOutlet weak var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL (string: "\(domain)/index.php")
        let requestObj = NSURLRequest(URL: url!)
        //webView.loadRequest(requestObj)
        webView.delegate = self
        println(prefs.integerForKey("ISLOGGEDIN"))
        if prefs.integerForKey("ISLOGGEDIN") == 1 {
            var username: AnyObject? = prefs.objectForKey("USERNAME")
            var password: AnyObject? = prefs.objectForKey("PASSWORD")
            if ( username!.isEqualToString("") || password!.isEqualToString("") ) {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in failed!"
                alertView.message = "Please enter a valid username and password."
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
            else {
                var post:NSString = "username=\(username!)&password=\(password!)"
                
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

        }
    }
    
    @IBAction func logoutPressed(sender: UIBarButtonItem) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        let url = NSURL (string: "\(domain)/logout.php")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
        webView.delegate = self
        println(prefs.integerForKey("ISLOGGEDIN"))
        loggedInServer = false
        self.performSegueWithIdentifier("gotologin", sender: self)
        loadingView.hidden = false
    }
    
    @IBAction func cancelToMainViewController(segue:UIStoryboardSegue) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let url = NSURL (string: "\(domain)/index.php")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
        webView.delegate = self
        self.manager = CLLocationManager()
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        println(prefs.objectForKey("USERNAME"))
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        prefs.setObject("\(locValue.latitude)", forKey: "LATITUDE")
        prefs.setObject("\(locValue.longitude)", forKey: "LONGITUDE")
        self.manager.stopUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Epic Fail")
    }


    @IBOutlet var webView: UIWebView!
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        println("WebView finished loading. URL is:")
        lastURL = webView.request?.URL
        println(lastURL)
        if lastURL!.isEqual(trainURL) {
            let url = NSURL (string: "\(domain)/user_train.php?location=" + prefs.stringForKey("LATITUDE")! + "%2C" + prefs.stringForKey("LONGITUDE")!)
            println(url)
            let requestObj = NSURLRequest(URL: url!)
            webView.loadRequest(requestObj)
        }
        else {
            if lastURL!.isEqual(loginURL) {
                loggedInServer = false
                self.performSegueWithIdentifier("gotologin", sender: self)
                println("BOSCOBOSCOSIDAJFOISDJ")
                prefs.setInteger(0, forKey: "ISLOGGEDIN")
            }
            else if "\(lastURL)".hasPrefix("\(loginURL)") {
                loggedInServer = false
                println("BOSCOBOSCOSIDAJFOISDJ3")
                self.performSegueWithIdentifier("gotologin", sender: self)
                prefs.setInteger(0, forKey: "ISLOGGEDIN")
            }
            else {
                loadingView.hidden = true
                loggedInServer = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

