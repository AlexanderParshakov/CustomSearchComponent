//
//  CustomSearchBar.swift
//  SearchComponent
//
//  Created by Alexander Parshakov on 19.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSearchBar: UITextField {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var imageView: UIImageView = UIImageView()
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = .always
            
            imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            
            let rImageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 10, height: 20))
            
            var width = 20 + leftPadding
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width += 7
            }
            
            let lView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            lView.addSubview(imageView)
            leftView = lView
            
            let rView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            rView.addSubview(rImageView)
            rightView = rView
        }
        else {
            leftViewMode = .never
        }
    }
}
