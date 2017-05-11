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
    
    @IBOutlet var popUpScanView: PopUpScanView!
    @IBOutlet var cartButton: ShoppingCartButton!
    @IBOutlet var addButton: CircleButton!
    var test: ItemData = ItemData()
    var delegate: ShoppingCartDelegate?
    let shapeLayerButton = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        test.hitagId = "11123123"
        test.size = "M"
        test.color = UIColor.black
        test.id = 123
        test.code = "cdsfsdf"
        test.price = Float("12")
        
        delegate = cartButton
        delegate?.countDidChange(String(ShoppingCartManager.shared.basket.count))
        cartButton.delegate = self
        
        popUpScanView.setSizePrice(size: "S", price:test.price!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.drawBorder(shapeLayer: shapeLayerButton,width:5)
        shapeLayerButton.strokeColor = UIColor.buddyGreen().cgColor
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! ShoppingBasketViewController
        detailVC.delegate = cartButton
    }
    
    func buttonWasPressed(_ data: UIButton) {
        performSegue(withIdentifier: "shoppingCart", sender: self)

    }
    @IBAction func dismissController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addButtonAction(_ sender: Any) {

        ShoppingCartManager.shared.basket[test.hitagId!] = test
        let count = String(ShoppingCartManager.shared.basket.count)
        delegate?.countDidChange(count)
        self.dismiss(animated: true, completion: nil)
    }
}