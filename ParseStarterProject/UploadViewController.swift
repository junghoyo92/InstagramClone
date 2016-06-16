//
//  UploadViewController.swift
//  Instagram Clone 0
//
//  Created by Hoyoung Jung on 3/3/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

@available(iOS 8.0, *)
class UploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    // next two functions are utilized to remove the keyboard by the return key or touching outside of the keyboard
    // it is the called in the viewDidLoad method below.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    @IBOutlet var imageToPost: UIImageView!
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        // sets source of picture -> can switch photolibrary to camera to take a picture to post
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    // occurs when a user has finished picking their image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        
    }
    
    @IBOutlet var message: UITextField!
    
    @IBAction func postImage(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        let post = PFObject(className: "Post")
        
        post["message"] = message.text
        
        post["userID"] = PFUser.currentUser()?.objectId!
        
        // this adds a compression and makes it a jpeg which is better for upload
        let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.7)
        
        
        //2 creates an image file from the above
        let imageFile = PFFile(name: "image.jpeg", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                
                self.displayAlert("Image Posted", message: "Image is succesfully posted")
                
                self.imageToPost.image = UIImage(named: "placeholder.png")
                
                self.message.text = ""
                
            } else {
                self.displayAlert("Post Unsuccessful", message: "Please try again or select a different image")
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.message.delegate = self
    }

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
