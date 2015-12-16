//
//  ViewController.swift
//  Instagram Clone
//
//  Created by Jonathan Mitchell on 12/15/15.
//  Copyright © 2015 nuapps. All rights reserved.
//






import UIKit
import Parse


class ViewController: UIViewController {
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!

    
    @IBOutlet weak var topButton: UIButton!
    

    @IBOutlet weak var bottomButton: UIButton!

    @IBOutlet weak var bottomLabelText: UILabel!
    
    var registerIsShown:Bool = true
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func initialize(){
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .Gray
    }
    
    func showDismissableAlert(title:String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action:UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func pauseApp(){
        initialize()
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func resumeApp(){
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        activityIndicator.stopAnimating()
    }
    
    
    
    @IBAction func signUp(sender: AnyObject) {
        
        if userName.text == "" || password.text == "" {
            showDismissableAlert("Bad Input", message: "You didn't enter anything in the username and/or password field")
            return
        }
        
        pauseApp()
        
        
        
        if registerIsShown {
            
            let user = PFUser()
            user.username = self.userName.text
            user.password = self.password.text
            
            
            user.signUpInBackgroundWithBlock { (isSuccess, error) -> Void in
                
                self.resumeApp()
                
                if error != nil { //failed
                    
                    if let errorString = error!.userInfo["error"] as? NSString {
                        self.showDismissableAlert("Error", message: String(errorString))
                    } else {
                        self.showDismissableAlert("Error", message: "Please try again")
                    }
                    return
                }
                
                //Success
                self.showDismissableAlert("Success!", message: "You are successfully registered!")
            }
        } else {
            PFUser.logInWithUsernameInBackground(self.userName.text!, password: self.password.text!, block: { (user:PFUser?, error:NSError?) -> Void in
                
                self.resumeApp()
                
                if user == nil {
                    
                    if let errorString = error!.userInfo["error"] as? NSString {
                        self.showDismissableAlert("Error", message: String(errorString))
                    } else {
                        self.showDismissableAlert("Error", message: "Please try again")
                    }
                    return
                }
                
                //Successful login
                print("Login successful! \(user)")
                self.performSegueWithIdentifier("loginSegue", sender: self)
                
                
                
                
            })
        }
        
    }
    
    @IBAction func login(sender: AnyObject) {
        
        if registerIsShown {
            topButton.setTitle("Log In", forState: UIControlState.Normal)
            bottomLabelText.text = "Not Registered?"
            bottomButton.setTitle("Sign Up", forState: UIControlState.Normal)
        } else {
            topButton.setTitle("Sign Up", forState: UIControlState.Normal)
            bottomLabelText.text = "Already Registered?"
            bottomButton.setTitle("Log In", forState: UIControlState.Normal)
        }
        
        
        registerIsShown = !registerIsShown
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
        
        
    }
    
    //Segues dont exist on viewdidLoad
    override func viewDidAppear(animated: Bool) {
        
        /*if PFUser.currentUser() != nil{
            print("Loging in with previous logged in user!")
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }*/
        
    }
    
    
    
    
}

