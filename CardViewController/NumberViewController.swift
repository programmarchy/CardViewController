//
//  ViewController.swift
//  CardViewController
//
//  Created by Donald Ness on 1/4/19.
//  Copyright © 2019 Programmarchy, LLC. All rights reserved.
//

import UIKit

class NumberViewController: UIViewController {

    var number: Int = 0
    
    @IBOutlet var numberLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberLabel?.text = String(number)
    }
    
}

@IBDesignable
class BorderView: UIView {
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
        
        layer.cornerRadius = 10
    }
    
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
    }
    
}
