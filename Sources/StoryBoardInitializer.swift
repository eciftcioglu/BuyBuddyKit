//
//  testfunc.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 08/05/2017.
//
//

import Foundation
import UIKit

public class StoryBoardInitializer{
    
    public class  func callStoryboard(param:UIViewController){
         if let vc = UIStoryboard(name: "BuyBuddyViews", bundle: Bundle(for: ScanViewController.self)).instantiateViewController(withIdentifier: "firstVC") as? ScanViewController
         {
         param.modalTransitionStyle = .crossDissolve
         param.modalPresentationStyle = .overCurrentContext
         param.present(vc, animated: true, completion: nil)
         }
     }
}


