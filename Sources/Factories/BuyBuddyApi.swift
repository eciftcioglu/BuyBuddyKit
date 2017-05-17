//
//  BuyBuddyApi.swift
//  BuyBuddyKit
//
//  Created by Furkan on 5/16/17.
//
//

import Foundation
import Alamofire
import ObjectMapper

enum BuyBuddyEndpoint : String {
    case QrHitag = "GET /iot/scan/<hitag_id>"
    case ScanHitag = "POST /iot/scan_record"
    case GetJwt = "POST /iam/users/tokens"
    case OrderDelegate = "POST /order/delegate"
}

public protocol BuyBuddyInvalidTokenDelegate{
    func tokenExpired()
}

public class BuyBuddyApi {
    
    public static let sandBoxPrefix = "sandbox-api";
    public static let productionPrefix = "api";
    public static var isSandBox: Bool = false
    private static var inited: Bool = false
    
    public static let sharedInstance: BuyBuddyApi = BuyBuddyApi()
    private let buyBuddySessionManager = SessionManager()
    private var userCurrentJwt = BuyBuddyUserJwt.getCurrentJwt()
    private var currentAccessToken: String?
    var tokenDelegate: BuyBuddyInvalidTokenDelegate?
    var isAccessTokenSet = false
    
    public static var getBaseUrl: String {
        return "https://" + (BuyBuddyApi.isSandBox ? BuyBuddyApi.sandBoxPrefix : BuyBuddyApi.productionPrefix) + ".buybuddy.co"
    }
    
    public func sandBoxMode(isActive: Bool){
        BuyBuddyApi.isSandBox = isActive
    }

    public init(){
        if let accessToken = Utilities.getFromUd(key: "access_token") as? String {
            currentAccessToken = accessToken
            userCurrentJwt = BuyBuddyUserJwt.getCurrentJwt()
            set(accessToken: accessToken)
            self.isAccessTokenSet = false
        }else{
            self.isAccessTokenSet = true
        }
    }
    
    public func set(accessToken: String){
        Utilities.saveToUd(key: "access_token", value: accessToken)
        currentAccessToken = accessToken
        isAccessTokenSet = true
        
        
        
        if userCurrentJwt == nil{
            getJwt(accessToken: accessToken, success: { (jwt :BuyBuddyObject<BuyBuddyUserJwt>, response) in
                
                DispatchQueue.main.async {
                    BuyBuddyUserJwt.setCurrentJwt(jwt: jwt.data!)
                    self.userCurrentJwt = jwt.data!
                    
                    let jwtHandler = BuyBuddyJwtAdapter(accessToken: accessToken,
                                                        jwt: jwt.data!,
                                                        sessionManager: self.buyBuddySessionManager,
                                                        tokenDelegate: self.tokenDelegate)
                    
                    self.buyBuddySessionManager.adapter = jwtHandler
                    self.buyBuddySessionManager.retrier = jwtHandler
                }
                
            }, error: { (error, response) in
                DispatchQueue.main.async {
                  self.tokenDelegate?.tokenExpired()
                }
            })
        }else{
            
            let jwtHandler = BuyBuddyJwtAdapter(accessToken: accessToken,
                                                jwt: userCurrentJwt,
                                                sessionManager: self.buyBuddySessionManager,
                                                tokenDelegate: self.tokenDelegate)
            
            self.buyBuddySessionManager.adapter = jwtHandler
            self.buyBuddySessionManager.retrier = jwtHandler
        }
    }
    
    public func set(invalidTokenDelegate: BuyBuddyInvalidTokenDelegate){
        self.tokenDelegate = invalidTokenDelegate
    }
    
    public typealias SuccessHandler<T: Mappable> = (_ result: T, _ operation: HTTPURLResponse?)
        -> Void
    public typealias ErrorHandler = (_ error: Error, _ operation: HTTPURLResponse?)
        -> Void
    
    func call<T: Mappable>(endPoint: BuyBuddyEndpoint,
              parameters: [String : Any],
              method: HTTPMethod? = .get,
              success: @escaping (SuccessHandler<T>),
              error: @escaping (ErrorHandler)){
        
        if !isAccessTokenSet {
            //"UYARI 1" Kullanıcıya bir token atanmadan sdk çalışmayacaktır.
            print("Access Token Setlemeniz Gerekiyor")
            return
        }
        
        let endPoint = Endpoint.buildURL(endPoint: endPoint.rawValue, values: parameters as [String : AnyObject])
        
        buyBuddySessionManager.request(endPoint.URL.absoluteString!,
                                       method: endPoint.method,
                                       parameters: endPoint.otherValues,
                                       encoding: JSONEncoding.default)
            .validate()
            .responseJSON { (response) in
            
                if response.error != nil{
                    print(response.error)
                    return error(response.error!, response.response)
                }
                
                switch response.result {
                case .success(let value):
                    let result = Mapper<T>().map(JSON: value as! [String: Any])
                    
                    if result != nil{
                        success(result!, response.response)
                    }else{
                        
                    }
                    break
                case .failure(let err):
                    error(err, response.response)
            }
        }
    }

    public func getProductWith(hitagId: String,
                        success: @escaping  (SuccessHandler<BuyBuddyObject<ItemData>>),
                        error: @escaping (ErrorHandler)){
        
        call(endPoint: BuyBuddyEndpoint.QrHitag, parameters: ["hitag_id" : hitagId], success: success, error: error)
    }
    
    func postScanRecord(hitags: [CollectedHitag],
                        success: @escaping  (SuccessHandler<ItemData>),
                        error: @escaping (ErrorHandler)){
        
        call(endPoint: BuyBuddyEndpoint.ScanHitag, parameters: ["collected_hitags" : hitags], method: HTTPMethod.post, success: success, error: error)
    }
    
    public func createOrder(hitagsIds: [Int], sub_total: Float,
                     success: @escaping  (SuccessHandler<OrderDelegateResponse>),
                     error: @escaping (ErrorHandler)) {
        
        call(endPoint: BuyBuddyEndpoint.OrderDelegate,
             parameters: ["order_delegate" : ["hitags": hitagsIds,
                                              "sub_total": sub_total]],
             success: success,
             error: error)
    }
    
    func completeOrder(orderId: Int,
                       success: @escaping  (SuccessHandler<ItemData>),
                       error: @escaping (ErrorHandler)) {
        
        
    }
    
    public func getJwt(accessToken: String,
                        success: @escaping  (SuccessHandler<BuyBuddyObject<BuyBuddyUserJwt>>),
                        error: @escaping (ErrorHandler)) {
        
        call(endPoint: BuyBuddyEndpoint.GetJwt,
             parameters: ["passphrase_submission" : ["passkey": accessToken]],
             success: success,
             error: error)
    }
}


