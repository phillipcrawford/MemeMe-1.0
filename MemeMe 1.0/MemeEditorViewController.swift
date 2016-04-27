//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Phillip Crawford on 4/22/16.
//  Copyright © 2016 Phillip Crawford. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.text = "TOP"
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.delegate = self
        
        bottomTextField.text = "BOTTOM"
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        //shareButton.enabled = false
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // Image Picker Delegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = .ScaleAspectFit
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Textfield Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // Textfield Attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]

    // Move Keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Generate Memed Image
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        //Create the meme
        let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage:
            imagePickerView.image!, memedImage: memedImage)
    }
    @IBAction func activityViewController(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(shareController, animated: true, completion: nil)
        shareController.completionWithItemsHandler = { activity, completed, items, error -> Void in
            if completed {
                self.save(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    @IBAction func reloadPage(sender: AnyObject) {
        viewDidLoad()
        viewWillAppear(true)
        imagePickerView.image = nil
    }
    
}

