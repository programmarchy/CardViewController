//
//  CardViewController.swift
//  CardViewController
//
//  Created by Donald Ness on 1/30/19.
//  Copyright © 2019 Programmarchy, LLC. All rights reserved.
//

import UIKit

extension CardViewController {
    
    public enum NavigationOrientation : Int {
        case horizontal
        case vertical
    }
    
    public enum NavigationDirection : Int {
        case forward
        case reverse
    }
    
}

open class CardViewController : UIViewController, UIScrollViewDelegate {
    
    public required init?(coder aDecoder: NSCoder) {
        navigationOrientation = .horizontal
        super.init(coder: aDecoder)
    }
    
    public init(navigationOrientation: NavigationOrientation = .horizontal) {
        self.navigationOrientation = navigationOrientation
        super.init(nibName: nil, bundle: nil)
    }
    
    weak open var delegate: CardViewControllerDelegate?
    weak open var dataSource: CardViewControllerDataSource?
    
    let navigationOrientation: NavigationOrientation
    
    public var numberOfCardsToPreload: Int {
        guard let dataSource = dataSource else {
            return 1
        }
        
        return dataSource.cardViewControllerNumberOfCardsToPreload(self)
    }
    
    // MARK: Card View
    
    public internal(set) var cardView: CardView!
    
    override open func loadView() {
        cardView = CardView()
        
        view = cardView
        
        cardView.scrollView.delegate = self
    }
    
    // MARK: View Controllers
    
    private var currentViewController: UIViewController?
    private var viewControllers: [UIViewController]?
    
    func setViewController(_ viewController: UIViewController, animated: Bool, completion: ((Bool) -> Void)?) {
        currentViewController = viewController
        
        reloadViewControllers()
    }
    
    private func loadViewControllersBefore(_ viewController: UIViewController) -> [UIViewController] {
        var viewControllers = [UIViewController]()
        
        var currentViewController: UIViewController = viewController
        
        for _ in 0 ..< numberOfCardsToPreload {
            guard let previousViewController = dataSource?.cardViewController(self, viewControllerBefore: currentViewController) else {
                break
            }
            
            viewControllers.insert(previousViewController, at: 0)
            
            currentViewController = previousViewController
        }
        
        return viewControllers
    }
    
    private func loadViewControllersAfter(_ viewController: UIViewController) -> [UIViewController] {
        var viewControllers = [UIViewController]()
        
        var currentViewController: UIViewController = viewController
        
        for _ in 0 ..< numberOfCardsToPreload {
            guard let nextViewController = dataSource?.cardViewController(self, viewControllerAfter: currentViewController) else {
                break
            }
            
            viewControllers.append(nextViewController)
            
            currentViewController = nextViewController
        }
        
        return viewControllers
    }
    
    private func reloadViewControllers() {
        removeAllViewControllers()
        
        guard let currentViewController = currentViewController else {
            return
        }
        
        let previousViewControllers = loadViewControllersBefore(currentViewController)
        let nextViewControllers = loadViewControllersAfter(currentViewController)
        
        let viewControllers = previousViewControllers + [ currentViewController ] + nextViewControllers
        
        viewControllers.forEach { viewController in
            addViewController(viewController)
        }
        
        self.viewControllers = viewControllers
        
        cardView.layoutSubviews()
    }
    
    private func addViewController(_ viewController: UIViewController) {
        addChild(viewController)
        cardView.scrollView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    private func removeViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func removeAllViewControllers() {
        viewControllers?.forEach { viewController in
            self.removeViewController(viewController)
        }
    }
    
    // MARK: - Scroll View Delegate
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = false
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = true

        guard let index = cardView.scrollIndex else {
            return
        }
        
        guard let viewControllers = viewControllers else {
            return
        }
        
        guard index >= 0 else {
            return
        }
        
        guard index < viewControllers.count else {
            return
        }
        
        currentViewController = viewControllers[index]
        
        reloadViewControllers()
        
        guard let currentViewController = currentViewController else {
            return
        }
        
        guard let newIndex = self.viewControllers?.firstIndex(of: currentViewController) else {
            return
        }
        
        cardView.setScrollIndex(newIndex)
    }
    
}

@objc public protocol CardViewControllerDelegate : NSObjectProtocol {
    
    @objc optional func cardViewController(_ cardViewController: CardViewController, willTransitionTo pendingViewController: UIViewController)
    
}

@objc public protocol CardViewControllerDataSource : NSObjectProtocol {
    
    @objc func cardViewControllerNumberOfCardsToPreload(_ cardViewController: CardViewController) -> Int
    
    @objc func cardViewController(_ cardViewController: CardViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    
    @objc func cardViewController(_ cardViewController: CardViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    
}

public class CardView: UIView {
    
    public required init?(coder aDecoder: NSCoder) {
        scrollView = UIScrollView(frame: CGRect.zero)
        
        super.init(coder: aDecoder)
        
        addScrollView()
    }
    
    override public init(frame: CGRect) {
        scrollView = UIScrollView(frame: frame)
        
        super.init(frame: frame)
        
        addScrollView()
    }
    
    public let scrollView: UIScrollView
    
    private func addScrollView() {
        addSubview(scrollView)
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    override public var clipsToBounds: Bool {
        didSet {
            scrollView.clipsToBounds = clipsToBounds
        }
    }
    
    var contentInset: UIEdgeInsets {
        get {
            return scrollView.contentInset
        }
        set {
            scrollView.contentInset = newValue
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        
        let views = scrollView.subviews
        guard views.count > 0 else {
            return
        }
        
        let w = bounds.width
        let h = bounds.height
        var x = frame.minX
        
        for i in 0 ..< views.count {
            let view = views[i]
            
            view.frame = CGRect(x: x, y: 0, width: w, height: h)
            
            x += w
        }
        
        scrollView.contentSize = CGSize(width: x, height: h)
    }
    
    internal var scrollIndex: Int? {
        guard scrollView.frame.width > 0 else {
            return nil
        }
        
        return Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    internal func setScrollIndex(_ scrollIndex: Int) {
        var contentOffset = scrollView.contentOffset
        contentOffset.x = CGFloat(scrollIndex) * scrollView.frame.width
        scrollView.contentOffset = contentOffset
    }
    
}
