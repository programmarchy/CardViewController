//
//  ExampleCardViewController.swift
//  CardViewController
//
//  Created by Donald Ness on 1/30/19.
//  Copyright © 2019 Programmarchy, LLC. All rights reserved.
//

import UIKit

class ExampleCardViewController: CardViewController, CardViewControllerDataSource {
    var cards: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let card1 = createViewController(1)
        let card2 = createViewController(2)
        let card3 = createViewController(3)
        let card4 = createViewController(4)
        let card5 = createViewController(5)
        let card6 = createViewController(6)
        let card7 = createViewController(7)
        let card8 = createViewController(8)
        let card9 = createViewController(9)
        
        cards = [card1, card2, card3, card4, card5, card6, card7, card8, card9]
        
        dataSource = self
        
        setViewController(card1, animated: false, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardView.clipsToBounds = false
    }
    
    func createViewController(_ number: Int) -> NumberViewController {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "numberViewController") as? NumberViewController
        viewController?.number = number
        return viewController!
    }
    
    func cardViewController(_ cardViewController: CardViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = cards.firstIndex(of: viewController) else {
            return nil
        }
        
        guard index > 0 else {
            return nil
        }
        
        return cards[index - 1]
    }
    
    func cardViewController(_ cardViewController: CardViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = cards.firstIndex(of: viewController) else {
            return nil
        }
        
        guard index + 1 < cards.count else {
            return nil
        }
        
        return cards[index + 1]
    }
    
    func cardViewControllerNumberOfCardsToPreload(_ cardViewController: CardViewController) -> Int {
        return 2
    }
    
}
