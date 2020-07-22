//
//  StepContainerDelegate.swift
//  Olimpia
//
//  Created by Julian on 21/07/20.
//  Copyright © 2020 Julian. All rights reserved.
//

import Foundation
import UIKit

protocol StepContainerDelegate {
    
    func updatePersonalData(
        name : String,
        idNumber : String,
        address : String,
        city : String,
        country : String,
        phoneNumber : String
    )
    
    func updatePicturePath(currentPhotoPath: UIImage)
    
    func updateCurrentLocation(latitude: String, longitude : String)
    
    func updateWBStatus(wifi : String, bluetooth : String)
    
    func getUserInfo() -> UserAppInfo
    
}
