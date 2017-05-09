//
//  ScanViewController.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 08/05/2017.
//
//

import Foundation
import UIKit


class ScanViewController:UIViewController,ShoppingCartButtonDelegate{
    
    @IBOutlet var addButton: CircleButton!
    var test: ItemData = ItemData()
    var delegate: ShoppingCartDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test.size = "M"
        test.color = UIColor.black
        test.id = 123
        test.code = "cdsfsdf"
        
    
    }
    
    func buttonWasPressed(_ data: UIButton) {
        performSegue(withIdentifier: "shoppingCart", sender: self)

    }

    @IBAction func addButtonAction(_ sender: Any) {

        ShoppingCartManager.shared.basket = ["123123123": test]
        let count = String(ShoppingCartManager.shared.basket.count)
        delegate?.countDidChange(count)    }
}
