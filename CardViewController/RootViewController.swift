//
//  RootViewController.swift
//  CardViewController
//
//  Created by Donald Ness on 1/4/19.
//  Copyright © 2019 Programmarchy, LLC. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet var cardContainerView: UIView?
    @IBOutlet var pageContainerView: UIView?
    
    @IBAction func changeContainerView(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            showCardContainerView()
        case 1:
            showPageContainerView()
        default:
            break
        }
    }
    
    private func showCardContainerView() {
        cardContainerView?.isHidden = false
        pageContainerView?.isHidden = true
    }
    
    private func showPageContainerView() {
        pageContainerView?.isHidden = false
        cardContainerView?.isHidden = true
    }
    
}
