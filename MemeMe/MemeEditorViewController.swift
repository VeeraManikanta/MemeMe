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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerView.contentMode = .scaleAspectFit
        configureTextField(textField: textField1)
        configureTextField(textField: textField2)
        textField1.text="TOP"
        textField2.text="BOTTOM"
        
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
    
    func configureTextField(textField : UITextField){
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
        textField.defaultTextAttributes = Meme.memeTextAttributes
        textField.borderStyle = .none
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
    
    
    func generateMemedImage() -> UIImage {
        
        toolBar1.isHidden = true
        toolBar2.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar1.isHidden = false
        toolBar2.isHidden = false
        return memedImage
    }
    
    

    //Camera -- Album
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickImageWithSourceType(.camera)
    }

    @IBAction func pickImageFromAlbum(_ sender: Any) {
        pickImageWithSourceType(.photoLibrary)
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
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if textField2.isFirstResponder{
            view.frame.origin.y += getKeyboardHeight(notification)
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
