//
//  ShoppingBasketViewController.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 09/05/2017.
//
//

import UIKit

protocol ShoppingCartDelegate {
    func countDidChange(_ data:String)
}


class ShoppingBasketViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate{

    @IBOutlet var basketTotal: UILabel!
    var delegate: ShoppingCartDelegate?

    var tableData : [ItemData] = []
    var suggestedData : [ItemData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableData = Array(ShoppingCartManager.shared.basket.values)
        
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callPaymentPage(_ sender: Any) {
    }
}

extension ShoppingBasketViewController{

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return ShoppingCartManager.shared.basket.count
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let count = tableData.count
            let i = count-1
            
            for i in stride(from: i, through: 0, by: -1){
                
                if(indexPath.row == i){
                    
                    tableData.remove(at: i)
                }
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
        var total:Double = 0
        for p in tableData{
            total += p.price!
        }
        
        let count = String(tableData.count)
        delegate?.countDidChange(count)

    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartTableViewCell", for: indexPath) as! ShoppingCartTableViewCell
        let data = tableData[indexPath.row]
        
        cell.setData(data: data)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:100,height:100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionsCollectionViewCell", for: indexPath) as! SuggestionsCollectionViewCell
        let data = suggestedData[(indexPath as NSIndexPath).row]

        cell.setProductImage(image: data.image!)
        cell.setProductPrice(price: data.price!)
        //let data = filltable[(indexPath as NSIndexPath).row]
        return cell
    }
}
