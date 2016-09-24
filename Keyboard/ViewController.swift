//
//  ViewController.swift
//  Keyboard
//
//  Created by CS3714 on 9/24/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    
    
    // Instance variable holding the object reference of the Scroll View object
    
    @IBOutlet var scrollView: UIScrollView!
    
    
    
    // Instance variable holding the object references of the Image View object
    
    @IBOutlet var photoImageView: UIImageView!
    
    
    
    // Instance variable to hold the object reference of a Text Field object
    
    var activeTextField: UITextField?
    
    
    
    /*
     
     -----------------------
     
     MARK: - View Life Cycle
     
     -----------------------
     
     */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        // Designate self as a subscriber to Keyboard Notifications
        
        
        
        registerForKeyboardNotifications()
        
        
        
        // Style the profile photo to show in a circle
        
        
        
        photoImageView.layer.borderWidth = 0
        
        photoImageView.layer.borderColor = UIColor.black.cgColor
        
        
        
        // Set cornerRadius = a square UIImageView frame size width / 2
        
        // In our case, UIImageView height = width = 200 points
        
        
        
        photoImageView.layer.cornerRadius = 100
        
        photoImageView.clipsToBounds = true
        
    }
    
    
    
    /*
     
     ------------------------------
     
     MARK: - User Tapped Background
     
     ------------------------------
     
     */
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        
        /*
         
         "This method looks at the current view and its subview hierarchy for the text field that is
         
         currently the first responder. If it finds one, it asks that text field to resign as first responder.
         
         If the force parameter is set to true, the text field is never even asked; it is forced to resign." [Apple]
         
         */
        
        view.endEditing(true)
        
        
        
        // Displaying Keyboard may have shifted the Content View up. This method brings it back to its original position.
        
        setContentViewToItsOriginalPosition()
        
    }
    
    
    
    /*
     
     -----------------------------------------
     
     MARK: - Content View in Original Position
     
     -----------------------------------------
     
     */
    
    func setContentViewToItsOriginalPosition() {
        
        
        
        // Set contentInsets to top=64, left=0, bottom=0, and right=0
        
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(64.0, 0.0, 0, 0)
        
        
        
        // Set scrollView's contentInsets to top=64, left=0, bottom=0, and right=0
        
        scrollView.contentInset = contentInsets
        
        
        
        // Set scrollView's scrollIndicatorInsets to top=64, left=0, bottom=0, and right=0
        
        scrollView.scrollIndicatorInsets = contentInsets
        
    }
    
    
    
    /*
     
     ---------------------------------------
     
     MARK: - Handling Keyboard Notifications
     
     ---------------------------------------
     
     */
    
    
    
    // This method is called in viewDidLoad() to register self for keyboard notifications
    
    func registerForKeyboardNotifications() {
        
        
        
        // "A NotificationCenter object (or simply, notification center) provides a
        
        // mechanism for broadcasting information within a program." [Apple]
        
        
        
        // Obtain the object reference of the default notification center
        
        let notificationCenter = NotificationCenter.default
        
        
        
        // Add self as an Observer for the "Keyboard Will Show" notification by specifying
        
        // the name of the method to invoke upon that notification.
        
        notificationCenter.addObserver(self,
                                       
                                       selector:   #selector(ViewController.keyboardWillShow(_:)),    // <-- Call this method upon Keyboard Will SHOW Notification
            
            name:       NSNotification.Name.UIKeyboardWillShow,
            
            object:     nil)
        
        
        
        // Add self as an Observer for the "Keyboard Will Hide" notification by specifying
        
        // the name of the method to invoke upon that notification.
        
        notificationCenter.addObserver(self,
                                       
                                       selector:   #selector(ViewController.keyboardWillHide(_:)),    //  <-- Call this method upon Keyboard Will HIDE Notification
            
            name:       NSNotification.Name.UIKeyboardWillHide,
            
            object:     nil)
        
    }
    
    
    
    
    
    // This method is called upon the "Keyboard Will Show" notification
    
    func keyboardWillShow(_ sender: Notification) {
        
        
        
        // "userInfo, the user information dictionary stores any additional
        
        // objects that objects receiving the notification might use." [Apple]
        
        let info: NSDictionary = (sender as NSNotification).userInfo! as NSDictionary
        
        
        
        /*
         
         Key     = UIKeyboardFrameBeginUserInfoKey
         
         Value   = an NSValue object containing a CGRect that identifies the start frame of the keyboard in screen coordinates.
         
         */
        
        let value: NSValue = info.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
        
        
        
        // Obtain the size of the keyboard
        
        let keyboardSize: CGSize = value.cgRectValue.size
        
        
        
        // Create Edge Insets for the view.
        
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        
        
        
        // Set the distance that the content view is inset from the enclosing scroll view.
        
        scrollView.contentInset = contentInsets
        
        
        
        // Set the distance the scroll indicators are inset from the edge of the scroll view.
        
        scrollView.scrollIndicatorInsets = contentInsets
        
        
        
        //-----------------------------------------------------------------------------------
        
        // If active text field is hidden by keyboard, scroll the content up so it is visible
        
        //-----------------------------------------------------------------------------------
        
        
        
        // Obtain the frame size of the View
        
        var selfViewFrameSize: CGRect = self.view.frame
        
        
        
        // Subtract the keyboard height from the self's view height
        
        // and set it as the new height of the self's view
        
        selfViewFrameSize.size.height -= keyboardSize.height
        
        
        
        // Obtain the size of the active UITextField object
        
        let activeTextFieldRect: CGRect? = activeTextField!.frame
        
        
        
        // Obtain the active UITextField object's origin (x, y) coordinate
        
        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        
        
        
        
        
        if (!selfViewFrameSize.contains(activeTextFieldOrigin!)) {
            
            
            
            // If active UITextField object's origin is not contained within self's View Frame,
            
            // then scroll the content up so that the active UITextField object is visible
            
            
            
            scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
            
        }
        
    }
    
    
    
    // This method is called upon the "Keyboard Will Hide" notification
    
    func keyboardWillHide(_ sender: Notification) {
        
        
        
        // Set contentInsets to top=0, left=0, bottom=0, and right=0
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        
        
        
        // Set scrollView's contentInsets to top=0, left=0, bottom=0, and right=0
        
        scrollView.contentInset = contentInsets
        
        
        
        // Set scrollView's scrollIndicatorInsets to top=0, left=0, bottom=0, and right=0
        
        scrollView.scrollIndicatorInsets = contentInsets
        
    }
    
    
    
    /*
     
     ------------------------------------
     
     MARK: - UITextField Delegate Methods
     
     ------------------------------------
     
     */
    
    
    
    // This method is called when the user taps inside a text field
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        
        activeTextField = textField
        
    }
    
    
    
    /*
     
     This method is called when the user:
     
     (1) selects another UI object after editing in a text field
     
     (2) taps Return on the keyboard
     
     */
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        activeTextField = nil
        
        
        
        // Process the Text Entered by the User Here
        
    }
    
    
    
    // This method is called when the user taps Return on the keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        
        // Deactivate the text field and remove the keyboard
        
        textField.resignFirstResponder()
        
        
        
        // Bring the Content View back to its original position
        
        setContentViewToItsOriginalPosition()
        
        
        
        return true
        
    }
    
    
    
    /*
     
     ---------------------------------------------
     
     MARK: - Register and Unregister Notifications
     
     ---------------------------------------------
     
     */
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        super.viewWillAppear(animated)
        
        self.registerForKeyboardNotifications()
        
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    
}







