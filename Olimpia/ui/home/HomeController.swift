//
//  HomeController.swift
//  Olimpia
//
//  Created by Julian on 20/07/20.
//  Copyright © 2020 Julian. All rights reserved.
//

import Foundation
import UIKit


class HomeController: UIViewController {
    @IBAction func navigateToStepForm(_ sender: UIButton) {
        self.performSegue(withIdentifier: "navigateToStepForm", sender: self)
    }
    
}
