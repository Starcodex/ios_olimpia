//
//  StepDataController.swift
//  Olimpia
//
//  Created by Julian on 20/07/20.
//  Copyright © 2020 Julian. All rights reserved.
//

import Foundation
import UIKit

class StepDataController: UIViewController {
    
    var delegate : StepContainerDelegate?
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var idTxtField: UITextField!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    
    var invalid : [String] = []
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
        self.delegate = navigationController as? StepContainerDelegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

    }
    
    @objc func keyboard(notification: Notification){
 
        guard let keyboardUp = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return  }
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            self.bottomConstraint.constant = keyboardUp.height
        default:
            
            self.bottomConstraint.constant = 0
        }
 
    }

 
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func validateFormFields(_ sender: Any) {
        
        invalid = []
        setError(valid: validateField(field: nameTxtField),field: nameTxtField, fieldName: "Name")
        setError(valid: validateField(field: idTxtField),field: idTxtField, fieldName: "Id number")
        setError(valid: validateField(field: addressTxtField),field: addressTxtField, fieldName: "Address")
        setError(valid: validateField(field: cityTxtField),field: cityTxtField, fieldName: "City")
        setError(valid: validateField(field: countryTxtField),field: countryTxtField, fieldName: "Country")
        setError(valid: validateField(field: phoneTxtField),field: phoneTxtField, fieldName: "Phone number")
        
        if (invalid.count > 0){
            
            let message = "Fields "+invalid.joined(separator: ", ")+" are empty"
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            
            delegate?.updatePersonalData(
                name: nameTxtField.text!,
                idNumber: idTxtField.text!,
                address: addressTxtField.text!,
                city: cityTxtField.text!,
                country: countryTxtField.text!,
                phoneNumber: phoneTxtField.text!
            )
            self.performSegue(withIdentifier: "showStepPicture", sender: self)
        }
        
        
    }
    
    func setError(valid : Bool, field : UITextField, fieldName : String) -> Bool {
        if(!valid){
            invalid.append(fieldName)
        }
        
        return valid
    }
    
    
    func validateField(field: UITextField) -> Bool{
        let txt = field.text
        if(txt != nil){
            if(txt!.count > 0){
                return true
            }
        }
        
        return false
    }
    
}
