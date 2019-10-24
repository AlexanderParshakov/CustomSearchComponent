//
//  CustomClearButton.swift
//  SearchComponent
//
//  Created by Alexander Parshakov on 25.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomRightViewButton: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    @IBInspectable var textColor: UIColor = UIColor.clear {
        didSet {
            clearButton.setTitleColor(textColor, for: .normal)
        }
    }
    @IBInspectable var buttonText: String = "Очистить" {
        didSet {
            clearButton.setTitle(buttonText, for: .normal)
        }
    }
    
    
    func updateImage() {
        imageView.image = image
    }
    
    
}
