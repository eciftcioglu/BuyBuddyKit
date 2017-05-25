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
        
        self.navigationController?.isToolbarHidden = true
        userButtonDelegate = userButton
        delegate = cartButton
        delegate?.countDidChange(String(ShoppingBasketManager.shared.basket.count))
        cartButton.delegate = self

        popUpScanView.setSizePrice(size: (self.product.metadata?.size)!, price:self.product.price!)
        addButton.isUserInteractionEnabled = true
        
        
        downloadImage(imageURL: self.product.image!)
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

    func downloadImage(imageURL:String){
        let session = URLSession(configuration: .default)
        let myURL = URL(string: imageURL)! // We can force unwrap because we are 100% certain the constructor will not return nil in this case.
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: myURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                         let image = UIImage(data: imageData)
                        DispatchQueue.main.async(execute:{
                            if(image != nil){
                                self.popUpScanView.centerImage = image
                            }
                        })
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
       }
        downloadPicTask.resume()
    }
}

