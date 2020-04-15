//
//  customTextField.swift
//  Legend
//
//  Created by Daniel Castro on 4/11/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    required init?(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20.0
    }
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
