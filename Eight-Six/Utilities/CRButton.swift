//
//  CRButton.swift
//  Dory
//
//  Created by itay gervash on 02/09/2020.
//  Copyright © 2020 itay gervash. All rights reserved.
//

import UIKit

@IBDesignable
class CRButton: UIButton {
    
    @IBInspectable var cornerRadius: Int = 4
    @IBInspectable var roundedCorners: Bool = false

    //MARK: - inits
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = false
        applyCornerRadius()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = false
        applyCornerRadius()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.layer.masksToBounds = false
        applyCornerRadius()

    }
    
    private func applyCornerRadius() {
        self.layer.cornerRadius = CGFloat(cornerRadius)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if roundedCorners {
            self.layer.cornerRadius = self.bounds.height / 2
            cornerRadius = Int(self.layer.cornerRadius)
        }
    }

}
