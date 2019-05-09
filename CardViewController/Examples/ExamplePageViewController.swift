//
//  ExamplePageViewController.swift
//  CardViewController
//
//  Created by Donald Ness on 1/4/19.
//  Copyright © 2019 Programmarchy, LLC. All rights reserved.
//

import UIKit

class ExamplePageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pages: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let page1 = createViewController(1)
        let page2 = createViewController(2)
        let page3 = createViewController(3)
        let page4 = createViewController(4)
        let page5 = createViewController(5)
        
        pages = [page1, page2, page3, page4, page5]
        
        setViewControllers([page1], direction: .forward, animated: false, completion: nil)
        
        dataSource = self
    }
    
    var scrollView: UIScrollView? {
        return view.subviews.compactMap({ $0 as? UIScrollView }).first
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.clipsToBounds = false
        scrollView?.clipsToBounds = false
    }
    
    func createViewController(_ number: Int) -> NumberViewController {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "numberViewController") as? NumberViewController
        viewController?.number = number
        return viewController!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        guard index > 0 else {
            return nil
        }
        
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        guard index + 1 < pages.count else {
            return nil
        }
        
        return pages[index + 1]
    }
    
}
