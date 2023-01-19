//
//  UIView+Extention.swift
//  SampleMovieRect
//
//  Created by Sivakumar R on 19/01/23.
//

import Foundation
import UIKit

extension UIView {
    
    func setScreenCaptureProtection() {
        guard superview != nil else {
            for subview in subviews { //to avoid layer cyclic crash, when it is a topmost view, adding all its subviews in textfield's layer, TODO: Find a better logic.
                subview.setScreenCaptureProtection()
            }
            return
        }
        let guardTextField = UITextField()
        guardTextField.backgroundColor = .red
        guardTextField.translatesAutoresizingMaskIntoConstraints = false
        guardTextField.isSecureTextEntry = true
        addSubview(guardTextField)
        guardTextField.isUserInteractionEnabled = false
        sendSubviewToBack(guardTextField)
        layer.superlayer?.addSublayer(guardTextField.layer)
        guardTextField.layer.sublayers?.first?.addSublayer(layer)
        guardTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        guardTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        guardTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        guardTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOpacity = 1
      layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
    layer.shadowRadius = 5

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadow2(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
