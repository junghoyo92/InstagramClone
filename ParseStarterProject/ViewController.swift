/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

@available(iOS 8.0, *)
class ViewController: UIViewController {
  
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var signUpActive = true
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var enterButton: UIButton!
    
    @IBOutlet var switchText: UILabel!
    
    @IBOutlet var switchButton: UIButton!
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func bottomSwitch(sender: AnyObject) {
        
        if signUpActive == true {
            
            enterButton.setTitle("Log In", forState: UIControlState.Normal)
            switchText.text = "Not Registered?"
            switchButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signUpActive = false
            
        } else {
            
            enterButton.setTitle("Sign Up", forState: UIControlState.Normal)
            switchText.text = "Already a Member?"
            switchButton.setTitle("Log In", forState: UIControlState.Normal)
            
            signUpActive = true
            
        }
        
    }
    
    @IBAction func action(sender: AnyObject) {
        
        // Tests to check if username and password contain information
        // if not, user is alerted with an error message
        if username.text == "" || password.text == "" {
            
            displayAlert("Error in Form", message: "Please enter a username and password")
        
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)

            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again"
            
            if signUpActive == true {
                let user = PFUser()
                user.username = username.text
                user.password = password.text
            
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                    if error == nil {
                        // successfull signup -> what to do after signup is complete
                        self.signUpActive = false
                        
                    } else {
                    
                        if let errorString = error!.userInfo["error"] as? String {
                        
                            errorMessage = errorString
                        
                        }
                    
                        self.displayAlert("Failed SignUp", message: errorMessage)
                    
                    }
                
                })
            
            } else {
               
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        print("Logged In!")
                        
                        self.performSegueWithIdentifier("User List", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                            
                        }
                        
                        self.displayAlert("Failed Log In", message: errorMessage)
                        
                    }
                    
                })
                
            }
            
        }
        
        username.text = ""
        password.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let navController = self.navigationController {
            
            navController.navigationBarHidden = true
            self.navigationController?.toolbarHidden = true
            
        }
        /*
        let currentUser = PFUser.currentUser()?.objectId
        if currentUser != nil {
            self.performSegueWithIdentifier("User List", sender: self)
        }
*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
