//
//  ScanViewController.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 08/05/2017.
//
//

import Foundation
import UIKit


class ScanViewController:UIViewController,BuyBuddyCartButtonDelegate,BluetoothAlertDelegate{
    
    @IBOutlet var popUpScanView: PopUpScanView!
    @IBOutlet var cartButton: BuyBuddyCartButton!
    @IBOutlet var addButton: CircleButton!
    
    var product: ItemData = ItemData()
    var delegate: BuyBuddyCartButtonBadgeDelegate?
    var userButtonDelegate: BuyBuddyCartButtonBadgeDelegate?
    var userButton:BuyBuddyCartButton?
    let shapeLayerButton = CAShapeLayer()
    var hitagID:String?
    var hitags: [String:String] = [:]
    var blemanager : BuyBuddyBLEManager?
    var cache:NSCache<AnyObject, UIImage>!
    var downloadedImage = UIImage()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cache = NSCache()
        userButtonDelegate = userButton
        delegate = cartButton
        delegate?.countDidChange(String(ShoppingBasketManager.shared.basket.count))
        userButtonDelegate?.countDidChange(String(ShoppingBasketManager.shared.basket.count))
        cartButton.delegate = self

        popUpScanView.setSizePrice(size: (self.product.metadata?.size)!, price:self.product.price!)
        addButton.isUserInteractionEnabled = true
        
        downloadImage(imageURL: self.product.image!)
        /*
        hitags["01AABBCCDD"] = "4368d274e72d0b6865861aae4413e092744368d274e72d0b6865861aae4413e0920e5c"
        blemanager = BuyBuddyBLEManager(products: hitags)
 */

    }
    
    func stateChange() {
        
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

    @IBAction func dismissController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addButtonAction(_ sender: Any) {

        if(product.hitagId != nil){
            if(BuyBuddyHitagManager.validateActiveHitag(hitagId: product.hitagId!)){
        ShoppingBasketManager.shared.basket[product.hitagId!] = product
        ShoppingBasketManager.shared.basket[product.hitagId!]?.realImage = downloadedImage
                
        let count = String(ShoppingBasketManager.shared.basket.count)
        delegate?.countDidChange(count)
        userButtonDelegate?.countDidChange(count)
        self.dismiss(animated: true, completion: nil)
            }
            else{
                Utilities.showError(viewController:self,message: "Bluetooth'unuzun açık ve okuttuğunuz ürünün yakınınızda olduğundan emin olunuz!")
            }
        }
    }
   
    func buttonWasPressed(_ data: UIButton) {
        performSegue(withIdentifier: "shoppingCart", sender: self)
        
    }
}
extension ScanViewController{

    
    func downloadImage(imageURL:String){
        
        
        if let image = self.cache.object(forKey: imageURL as AnyObject){
                    self.popUpScanView.centerImage = image 
        }else{
            let session = URLSession(configuration: .default)
            let myURL = URL(string: imageURL)!
            let downloadPicTask = session.dataTask(with: myURL) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    // No errors found.
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded picture with response code \(res.statusCode)")
                        if let imageData = data {
                            // Finally convert that Data into an image and do what you wish with it.
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async(execute:{
                                if(image != nil){
                            
                                    self.popUpScanView.centerImage = image
                                    self.downloadedImage = image!
                                    self.cache.setObject(image!, forKey:imageURL as AnyObject!)
                                }
                            })
                            // Do something with your image.
                        } else {
                            self.popUpScanView.centerImage = UIImage(named: "missingImage", in: Bundle(for: type(of: self)), compatibleWith: nil)
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        self.popUpScanView.centerImage = UIImage(named: "missingImage", in: Bundle(for: type(of: self)), compatibleWith: nil)
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            downloadPicTask.resume()
        }
    }
}

