//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Apple on 21/11/17.
//  Copyright © 2017 Wipro. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate ,UITextFieldDelegate {

    @IBOutlet weak var toolBar2: UIToolbar!
    @IBOutlet weak var toolBar1: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerView.contentMode = .scaleAspectFit
        configureTextField(textField: textField1,text: "TOP")
        configureTextField(textField: textField2,text: "BOTTOM")
       
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        if imagePickerView.image == nil{
            shareButton.isEnabled = false
        }
        else{
             shareButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func configureTextField(textField : UITextField,text : String){
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.borderStyle = .none
        textField.text=text
    }
    
    
    //Share -- Cancel
    
    @IBAction func share(_ sender: Any) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.saveMeme()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        textField1.text="TOP"
        textField2.text="BOTTOM"
        imagePickerView.image=nil
        shareButton.isEnabled=false
    }
    
    func saveMeme() {
        let meme = Meme(topText: textField1.text!, bottomText: textField2.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    func toolBarVisibility(value : Bool){
        toolBar1.isHidden = value
        toolBar2.isHidden = value
    }
    
    func generateMemedImage() -> UIImage {
        
        toolBarVisibility(value: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBarVisibility(value: false)
        return memedImage
    }
    
   
    

    //Camera -- Album
    
    @IBAction func pickImage(_ sender: Any) {
        switch((sender as AnyObject).tag){
        case 0:
            pickImageWithSourceType(.camera)
        case 1:
            pickImageWithSourceType(.photoLibrary)
        default:
            print("Nothing is selected")
        }
        
    }
    
    
    func pickImageWithSourceType(_ sourceType: UIImagePickerControllerSourceType)  {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        self.present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
            
        }
        if imagePickerView.image == nil{
            shareButton.isEnabled = false
        }
        else{
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text=""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    
    
    
    //Keyboard
    
    func keyboardWillShow(_ notification:Notification) {
        if textField2.isFirstResponder{
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if textField2.isFirstResponder{
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }


}

