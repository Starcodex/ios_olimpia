//
//  StepPictureController.swift
//  Olimpia
//
//  Created by Julian on 20/07/20.
//  Copyright © 2020 Julian. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary


class StepPictureController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var delegate : StepContainerDelegate?
 
    var imagePicker = UIImagePickerController()
    
    @IBOutlet var imagePreview: UIImageView!
    
    override func viewDidLoad() {
      super.viewDidLoad()
       self.delegate = navigationController as? StepContainerDelegate
    }
    
    @IBAction func navigateToPrevious(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navigateToNext(_ sender: Any) {
        
        self.performSegue(withIdentifier: "showStepGeo", sender: self)        
    }
    
    
    
    @IBAction func loadPicture(_ sender: Any) {
        
        ImagePickerManager().pickImage(self){ image, info in
            print(info.keys)
            self.imagePreview.image = image
            let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL?
            if(imageURL != nil){
                // gallery
                self.delegate?.updatePicturePath(currentPhotoPath: image)
            }else{
                // camera
                ALAssetsLibrary().writeImage(toSavedPhotosAlbum: image.cgImage, orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!,
                               completionBlock:{ (path, error) -> Void in
                                self.delegate?.updatePicturePath(currentPhotoPath: image)
                           })
            }

        }
    }
    

    
}
