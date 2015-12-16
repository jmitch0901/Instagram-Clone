//
//  PostImageViewController.swift
//  Instagram Clone v2
//
//  Created by Jonathan Mitchell on 12/16/15.
//  Copyright © 2015 nuapps. All rights reserved.
//

import UIKit
import Parse
class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var imageToPost: UIImageView!
    @IBOutlet weak var message: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func initialize(){
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
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


    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = image
    }
    
    func uploadIsPrepared() -> Bool {
        
        if imageToPost.image == nil {
            self.showDismissableAlert("Error", message: "You must chose an image to upload!")
            return false
        }
        
        if message.text == nil || message.text == "" {
            self.showDismissableAlert("Error", message: "You must specify a post message!")
            return false
        }
        
        
        
        
        return true
    }

    @IBAction func upload(sender: AnyObject) {
        
        
        if !uploadIsPrepared() {
            return
        }

        self.pauseApp()
        
        let post = PFObject(className: "Post")
        post["message"] = message.text
        post["userId"] = PFUser.currentUser()!.objectId!
        
        let imageData = UIImagePNGRepresentation(imageToPost.image!)
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (isSuccess, error) -> Void in
            self.resumeApp()
            if error != nil {
                print("Error posting image")
                if let error = error {
                    self.showDismissableAlert("Error", message: String(error.description))
                } else {
                    self.showDismissableAlert("Error", message: "Server error, please try again!")

                }
                return
            }
            
            self.showDismissableAlert("Success!", message: "Your image was posted successfully!")
            self.message.text = ""
            self.imageToPost.image = nil
            
            print("Success")
        }
         
    }
    
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()

        
        // Do any additional setup after loading the view.
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
