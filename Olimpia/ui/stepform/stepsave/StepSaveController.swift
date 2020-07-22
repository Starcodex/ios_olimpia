//
//  StepSaveController.swift
//  Olimpia
//
//  Created by Julian on 20/07/20.
//  Copyright © 2020 Julian. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class StepSaveController: UIViewController {
 
    var delegate : StepContainerDelegate?
    
    override func viewDidLoad() {
      super.viewDidLoad()
        self.delegate = navigationController as? StepContainerDelegate

    }
    
    @IBAction func navigateToPrevious(_ sender: Any) {
             navigationController?.popViewController(animated: true)
    }

    @IBAction func saveUserInfo(_ sender: Any) {
        
        uploadUserInfoRemote()
        
    }
    
    func uploadUserInfoRemote(){
        
        let userInfo =  delegate?.getUserInfo()
        let apitoken = UserDefaults.standard.string(forKey: "api_token")
        print(apitoken)
        
        let headers : HTTPHeaders = [
            "Authorization": apitoken!
        ]
        
        let parameters: [String: String] = [
            "name" : userInfo?.name ?? "name",
            "id_number" : userInfo?.id_number ?? "id number",
            "address" : userInfo?.address ?? "address",
            "city" : userInfo?.city ?? "city",
            "country" : userInfo?.country ?? "country",
            "phone_number" : userInfo?.phone_number ?? "phone number",
            "latitude" : userInfo?.latitude ?? "latitude",
            "longitude" : userInfo?.longitude ?? "longitude",
            "wifi_status" : userInfo?.wifi_status ?? "wifi on",
            "bluetooth_status" : userInfo?.bluetooth_status ?? "bluetooth off"
        ]
    


        
        Alamofire.upload(
            multipartFormData: { multipartFormData in

                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }

                
                multipartFormData.append((userInfo?.picture)!.jpegData(compressionQuality: 0.2)! as Data, withName: "picture", fileName: "IMAGE-JPG.jpg",mimeType: "image/jpeg")


        },
            to: "https://pruebas.backtoide.com/api/auth/module/userappinfo/storeData",
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        let alert = UIAlertController(title: "User data uploaded", message: "Information has been uploaded successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        }))
                        self.present(alert, animated: true, completion: nil)

                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
          
    }

    
    
}
