//
//  StepContainerController.swift
//  Olimpia
//
//  Created by Julian on 20/07/20.
//  Copyright © 2020 Julian. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class StepContainerController: UINavigationController, StepContainerDelegate {
    
    var userInfo = UserAppInfo()
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
        getApiDataAccess()

    }
    
    func getApiDataAccess(){
        var expiration : String?
            expiration = UserDefaults.standard.string(forKey: "expires_at")
        if(expiration != nil){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateExpiration = dateFormatter.date(from: expiration ?? "")!
            let currentDate = Date()
            if(dateExpiration < currentDate){
                executeRemoteCall()
            }else{
                print("NOT EXPIRED")
            }
        }else{
            executeRemoteCall()
        }
    }
    
    func executeRemoteCall(){
        
        let dataAccess = AuthDataAccess()
        
        let parameters: [String: String] = [
            "email" : dataAccess.email,
            "password" : dataAccess.password,
            "password_confirmation" : dataAccess.password
        ]
        
        let headers : HTTPHeaders = [
            "X-Requested-With": "XMLHttpRequest",
            "Content-Type": "application/json"
        ]
        
        Alamofire.request("https://pruebas.backtoide.com/api/auth/login", method: .post , parameters: parameters, encoding:
            JSONEncoding.default, headers : headers)
        .responseJSON { response in
            switch response.result {
               case .success:
                    if let result = response.result.value as? NSDictionary{
                        self.saveLocalApiDataAccess(data: result)
                    }
                break

                case .failure(let error):
                 print(error)
            }
        }
    }
    
    
    func saveLocalApiDataAccess(data: NSDictionary){
        print(data)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data["access_token"], forKey: "access_token")
        userDefaults.set(data["token_type"], forKey: "token_type")
        userDefaults.set(data["expires_at"], forKey: "expires_at")
        userDefaults.set("\(data["token_type"]!) \(data["access_token"]!)", forKey: "api_token")
    }
    
    func updatePersonalData(name: String, idNumber: String, address: String, city: String, country: String, phoneNumber: String) {
        userInfo.name = name
        userInfo.id_number = idNumber
        userInfo.address = address
        userInfo.city = city
        userInfo.country = country
        userInfo.phone_number = phoneNumber
        print(name)
    }
    
    func updatePicturePath(currentPhotoPath currentPhoto: UIImage) {
        userInfo.picture = currentPhoto
    }
    
    func updateCurrentLocation(latitude: String, longitude: String) {
        userInfo.latitude = latitude
        userInfo.longitude = longitude
        print(latitude)
    }
    
    func updateWBStatus(wifi: String, bluetooth: String) {
        userInfo.wifi_status = wifi
        userInfo.bluetooth_status = bluetooth
        print(wifi)
    }
    
    func getUserInfo() -> UserAppInfo {
        return userInfo
    }
}
