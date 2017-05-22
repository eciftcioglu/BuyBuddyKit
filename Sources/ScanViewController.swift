//
//  ScanViewController.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 08/05/2017.
//
//

import Foundation
import UIKit


class ScanViewController:UIViewController,ShoppingBasketButtonDelegate{
    
    @IBOutlet var popUpScanView: PopUpScanView!
    @IBOutlet var cartButton: ShoppingCartButton!
    @IBOutlet var addButton: CircleButton!
    
    
    var product: ItemData = ItemData()
    var delegate: ShoppingBasketDelegate?
    var userButtonDelegate: ShoppingBasketDelegate?
    var userButton:ShoppingCartButton?
    let shapeLayerButton = CAShapeLayer()
    var hitagID:String?
    var hitags: [String:String] = [:]
    var blemanager : BuyBuddyBLEManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        userButtonDelegate = userButton
        delegate = cartButton
        delegate?.countDidChange(String(ShoppingBasketManager.shared.basket.count))
        cartButton.delegate = self
        
      
 
        /*
        hitags["01AABBCCDD"] = "4368d274e72d0b6865861aae4413e092744368d274e72d0b6865861aae4413e0920e5c"
        blemanager = BuyBuddyBLEManager(products: hitags)
 */
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        userButton?.fadeIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userButton?.fadeOut()
        
        if(checkDuplicate(id: hitagID!) == false){
            BuyBuddyApi.sharedInstance.getProductWith(hitagId: hitagID!, success: { (item: BuyBuddyObject<ItemData>, httpResponse) in
                
                self.product = item.data!
                self.popUpScanView.setSizePrice(size: (self.product.metadata?.size)!, price:self.product.price!)
                //popUpScanView.centerImage = self.product.image_url
                //popUpScanView.setSizePrice(size: product.size!, price:product.price!)
                
            }) { (err, httpResponse) in
                
            }
        }
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

    @IBAction func dismissController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addButtonAction(_ sender: Any) {

        if(product.hitagId != nil){
        ShoppingBasketManager.shared.basket[product.hitagId!] = product
        let count = String(ShoppingBasketManager.shared.basket.count)
        delegate?.countDidChange(count)
        userButtonDelegate?.countDidChange(count)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func buttonWasPressed(_ data: UIButton) {
        performSegue(withIdentifier: "shoppingCart", sender: self)
        
    }
    func checkDuplicate(id:String)->Bool{
        
        for (key,_) in ShoppingBasketManager.shared.basket{
            
            if(key == hitagID){
                DispatchQueue.main.async {
                    
                    let acceptAction = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default) { (_) -> Void in
                    }
                    let alertController = UIAlertController(title: "Uyarı!", message:"Aynı Hitag birden fazla kez eklenememektedir.Başka bir hitag okutunuz.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(acceptAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                return true
            }
        }
        return false
    }
}

