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
    
    var product: ItemData = ItemData()
    var delegate: ShoppingCartDelegate?
    var userButtonDelegate: ShoppingCartDelegate?
    var userButton:ShoppingCartButton?
    let shapeLayerButton = CAShapeLayer()
    var hitagID:String?
    var hitags: [String:String] = [:]
    var blemanager : BuyBuddyBLEManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        userButtonDelegate = userButton
        delegate = cartButton
        delegate?.countDidChange(String(ShoppingCartManager.shared.basket.count))
        cartButton.delegate = self
        
        if(hitagID != nil){
        BuyBuddyApi.sharedInstance.getProductWith(hitagId: hitagID!, success: { (item: BuyBuddyObject<ItemData>, httpResponse) in
            
            self.product = item.data!
            
        }) { (err, httpResponse) in
            
        }
    }
 
            /*
        hitags["01AABBCCDD"] = "4368d274e72d0b6865861aae4413e092744368d274e72d0b6865861aae4413e0920e5c"
        blemanager = BuyBuddyBLEManager(products: hitags)
 */
        
        //popUpScanView.centerImage = self.product.image_url
        //popUpScanView.setSizePrice(size: product.size!, price:product.price!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        userButton?.fadeIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userButton?.fadeOut()
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

        ShoppingCartManager.shared.basket[product.hitagId!] = product
        let count = String(ShoppingCartManager.shared.basket.count)
        delegate?.countDidChange(count)
        userButtonDelegate?.countDidChange(count)
        self.dismiss(animated: true, completion: nil)
    }
}
