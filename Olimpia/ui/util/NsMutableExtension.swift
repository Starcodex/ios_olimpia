//
//  NsMutableExtension.swift
//  Olimpia
//
//  Created by Julian on 21/07/20.
//  Copyright © 2020 Julian. All rights reserved.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
