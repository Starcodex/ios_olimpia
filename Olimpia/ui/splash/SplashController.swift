//
//  ViewController.swift
//  Olimpia
//
//  Created by Julian on 20/07/20.
//  Copyright © 2020 Julian. All rights reserved.
//

import UIKit
import Lottie

class SplashController: UIViewController {
    

    var animationView: AnimationView!
    
    override func viewDidLoad() {
      super.viewDidLoad()
        playSplashAnimation()
    }
    
    func playSplashAnimation(){

        animationView = .init(name: "splash_screen")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFill
        animationView!.animationSpeed = 1
        
        view.addSubview(animationView!)
        animationView!.play{ (finished) in
            self.navigateToHome()
        }
    }
    
    
    func navigateToHome() {
        self.performSegue(withIdentifier: "navigateToHome", sender: self)
    }


}

