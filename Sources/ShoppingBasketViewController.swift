//
//  ShoppingBasketViewController.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 09/05/2017.
//
//

import UIKit



class ShoppingBasketViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    @IBOutlet var titleText: UILabel!
    @IBOutlet var tableViewContainer: UIView!
    @IBOutlet var paymentButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var labelContainer: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var basketTotal: UILabel!
    var userButtonDelegate: BuyBuddyCartButtonBadgeDelegate?
    var userButton:BuyBuddyCartButton?
    var noDataLabel: UILabel = UILabel(frame:.zero)
    var delegate: BuyBuddyCartButtonBadgeDelegate?
    var hitagIds:[Int] = []
    var totalPrice:Float = 0
    var blemanager : BuyBuddyBLEManager?
    var tableData : [ItemData] = []
    var suggestedData : [ItemData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBlurEffect()
        tableView.delegate = self
        tableView.dataSource = self
        
        createTableLabel()
        
        //collectionView.dataSource = self
        //collectionView.delegate = self
        
        userButtonDelegate = userButton

        tableView.register(UINib(nibName: "ShoppingCartTableViewCell", bundle:Bundle(for: type(of: self))), forCellReuseIdentifier: "ShoppingCartTableViewCell")
        //collectionView.register(UINib(nibName: "SuggestionsCollectionViewCell", bundle:Bundle(for: type(of: self))), forCellWithReuseIdentifier: "SuggestionsCollectionViewCell")
        tableData = Array(ShoppingBasketManager.shared.basket.values)
        
    }
    
    override func viewDidLayoutSubviews() {
        labelContainer.roundedBottomCorner()
        tableViewContainer.roundedTopCorner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(tableData.isEmpty){
            paymentButton.isHidden = true
            collectionView.isHidden = true
            titleText.isHidden = true
            basketTotal.text = "0 TL"
        }else{
            paymentButton.isHidden = false
            collectionView.isHidden = false
            titleText.isHidden = false
        }
        totalPrice = 0
        for p in tableData{
            totalPrice += p.price!.current_price!
        }
        basketTotal.text = String(totalPrice) + " TL"
    }
    
    func createTableLabel(){
    
        noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text          = "Your Shopping Cart is Empty"
        noDataLabel.font = UIFont(name: "Avenir-Medium", size: 18)
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        //tableView.addSubview(noDataLabel)
        tableView.backgroundView  = noDataLabel
        tableView.separatorStyle  = .none
    
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        if(self.navigationController != nil){
            self.navigationController?.dismiss(animated: true, completion:nil)
        }
        else{
        
            self.dismiss(animated: true, completion: nil)

        }
    }
    
    @IBAction func callPaymentPage(_ sender: Any) {
        
        hitagIds.removeAll()
        for item in ShoppingBasketManager.shared.basket.values{
            hitagIds.append(item.h_id!)
        }
        print(totalPrice)
        
        for id in ShoppingBasketManager.shared.basket.values{
        
            if(!BuyBuddyHitagManager.validateActiveHitag(hitagId: id.hitagId!)){
                
                for index in 0..<hitagIds.count{
                
                    if(hitagIds[index] == id.h_id!){
                        hitagIds.remove(at: index)
                    }
                }
            }
        }
            BuyBuddyApi.sharedInstance.createOrder(hitagsIds: hitagIds, sub_total:totalPrice, success: { (orderResponse, httpResponse) in
                
                DispatchQueue.main.async(execute:{

                    self.dismiss(animated: true, completion: { 
                        BuyBuddyApi.sharedInstance.orderDelegate?.BuyBuddyOrderCreated(orderId: orderResponse.data!.sale_id!, basketTotal: orderResponse.data!.grand_total!)
                    })
                })
                
            }, error: { (err, httpResponse) in
                
            })
        

        /*let product = ItemData(hitagId: "0100000001")
        blemanager = BuyBuddyBLEManager(products: [product])*/
    }
}

extension ShoppingBasketViewController{

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(ShoppingBasketManager.shared.basket.values.isEmpty){
    
            noDataLabel.isHidden = false
        }
        
        else {
        
            noDataLabel.isHidden = true
        }

        return tableData.count
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
                    
                    let toDelete = tableData[i].hitagId
                    ShoppingBasketManager.shared.basket.removeValue(forKey: toDelete!)
                    tableData.remove(at: i)
                    
                }
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
        totalPrice = 0
        for p in tableData{
            totalPrice += p.price!.current_price!
        }
        basketTotal.text = String(totalPrice) + " TL"
        let count = String(tableData.count)
        delegate?.countDidChange(count)
        userButtonDelegate?.countDidChange(count)

        
        if(tableData.isEmpty){
            paymentButton.isHidden = true
            collectionView.isHidden = true
            titleText.isHidden = true
        }else{
            paymentButton.isHidden = false
            collectionView.isHidden = false
            titleText.isHidden = false
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartTableViewCell", for: indexPath) as! ShoppingCartTableViewCell
        var data = tableData[indexPath.row]
        
        data.description = "Grey Dress"
        cell.setData(data: data)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
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
        //let data = suggestedData[(indexPath as NSIndexPath).row]
        
        //cell.setProductImage(image: data.image!)
        //cell.setProductPrice(price: data.price!)
        
        cell.setProductImage(image: UIImage(named: "Oval_2", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
        cell.setProductPrice(price: 12)
        //let data = filltable[(indexPath as NSIndexPath).row]
        return cell
    }
}
