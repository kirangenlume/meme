//
//  ViewController.swift
//  MeMe 1.0
//
//  Created by kirang on 2/8/18.
//  Copyright © 2018 kirang. All rights reserved.
//

import UIKit
struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottopTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    
    
    var isTextFieldHidden: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        let memeTextAttributes: [String:Any] = [NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
                                                NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
                                                NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                                NSAttributedStringKey.strokeWidth.rawValue: -5]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottopTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.center
        bottopTextField.textAlignment = NSTextAlignment.center
        topTextField.delegate = self
        bottopTextField.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    func save() -> Meme{
        let meme = Meme(topText: topTextField.text!, bottomText: bottopTextField.text!, originalImage: selectedImage.image!, memedImage: generateMemedImage())
        return meme
    }
    func generateMemedImage() -> UIImage {
        
        topToolBar.isHidden = true
        bottomToolbar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        topToolBar.isHidden = false
        bottomToolbar.isHidden = false
        
        return memedImage
    }

    
    @IBAction func cancelSavedImage(_ sender: Any) {
    }
    
    @IBAction func exportImage(_ sender: Any) {
        var savedMeme: Meme = save()
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [savedMeme], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    
    //MARK:  barbutton methods
    @IBAction func clickCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func pickAnImage(_ sender: Any) {
        let viewController = UIImagePickerController()
        viewController.delegate = self
        present(viewController, animated:true, completion: nil)
    }
    
    //MARK: imagePicker Delegate Metods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage.contentMode = .scaleAspectFit
            selectedImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    //MARK: textField delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
     /*   if Let isTextFieldHidden == isTextFieldHidden {
            isTextFieldHidden = checkTextFieldView(textField)
        }*/
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func checkTextFieldView(_ textField: UITextField) -> Bool {
        if self.view.frame.height/2 > textField.frame.origin.y  {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Keyboard Methods
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottopTextField.isFirstResponder {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottopTextField.isFirstResponder {
        self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    // MARK: notification Methods
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
}

