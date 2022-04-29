//
//  UIViewExt.swift
//  NC1
//
//  Created by Minawati on 28/04/22.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
