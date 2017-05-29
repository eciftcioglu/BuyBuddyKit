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
    case OrderCompletion = "POST /order/delegate/<sale_id>/hitag_release"
    case HitagCompletionUpdate = "PUT /order/overview/<sale_id>/hitag_completion/<compile_id>"
    case HitagIncompleteOrder = "GET /order/uncompleted"
}

public protocol BuyBuddyInvalidTokenDelegate{
    func tokenExpired()
}

public protocol BuyBuddyApiErrorDelegate{
    func BuyBuddyApiDidErrorReceived(_ errorCode:NSInteger,errorResponse:BuyBuddyBase?)
}

public protocol BuyBuddyOrderCreatedDelegate{
    func BuyBuddyOrderCreated(orderId: Int, basketTotal: Float)
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
    var errorDelegate: BuyBuddyApiErrorDelegate?
    var orderDelegate: BuyBuddyOrderCreatedDelegate?
    
    var isAccessTokenSet = false
    
    public static var getBaseUrl: String {
        return "https://" + (BuyBuddyApi.isSandBox ? BuyBuddyApi.sandBoxPrefix : BuyBuddyApi.productionPrefix) + ".buybuddy.co"
    }
    
    public func sandBoxMode(isActive: Bool = false){
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
    
    public func set(orderDelegate: BuyBuddyOrderCreatedDelegate){
        self.orderDelegate = orderDelegate
    }
    public func set(errorDelegate:BuyBuddyApiErrorDelegate ){
        self.errorDelegate = errorDelegate
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
    
    public typealias SuccessHandler<T: Mappable> = (_ result: BuyBuddyObject<T>, _ operation: HTTPURLResponse?)
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
            .responseString { (response) in
                
     
                switch response.result {
                case .success(let value):
                    
                    let result = Mapper<BuyBuddyObject<T>>().map(JSONString: value )
                    
                    if result != nil{
                        success(result!, response.response)
                    }else{
                        if let jsonString = String(data: response.data!, encoding: .utf8) {
                            if let baseError = Mapper<BuyBuddyBase>().map(JSONString: jsonString) {
                            self.errorDelegate?.BuyBuddyApiDidErrorReceived((response.response?.statusCode)!,errorResponse: baseError)
                            }
                        }
                    }
                    break
                case .failure(let err):
                    
                    error(err, response.response)
            
                    if response.response == nil {
                    let error = BuyBuddyBase(error: BuyBuddyApiError(tracemessage: "Unknown Message", tracecode: "9000"))
                        self.errorDelegate?.BuyBuddyApiDidErrorReceived(-1 ,errorResponse: error)
                    }else{
                        if let jsonString = String(data: response.data!, encoding: .utf8) {
                            if let baseError = Mapper<BuyBuddyBase>().map(JSONString: jsonString) {
                            self.errorDelegate?.BuyBuddyApiDidErrorReceived((response.response?.statusCode)!,errorResponse: baseError)
                            }
                        }
                    }
                    
                    if response.data != nil{
                        if let jsonString = String(data: response.data!, encoding: .utf8) {
                            if let baseError = Mapper<BuyBuddyBase>().map(JSONString: jsonString) {
                                print(baseError)
                        self.errorDelegate?.BuyBuddyApiDidErrorReceived((response.response?.statusCode)!,errorResponse: baseError)
                            }
                        }
                    }
                }
            }
        }
    

    public func getProductWith(hitagId: String,
                        success: @escaping  (SuccessHandler<ItemData>),
                        error: @escaping (ErrorHandler)){
        
        let replaced_hitag_id = hitagId.replacingOccurrences(of: " ", with: "")
        
        call(endPoint: BuyBuddyEndpoint.QrHitag,
             parameters: ["hitag_id" : replaced_hitag_id],
             success: success,
             error: error)
    }
    
    func postScanRecord(hitags: [CollectedHitag],
                        success: @escaping  (SuccessHandler<BuyBuddyBase>),
                        error: @escaping (ErrorHandler)){
        
        call(endPoint: BuyBuddyEndpoint.ScanHitag, parameters: ["scan_record" : hitags.toJSON()], success: success, error: error)

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
                       hitagValidations: [String: Int],
                       success: @escaping  (SuccessHandler<HitagPassKeyResponse>),
                       error: @escaping (ErrorHandler)) {
        
        call(endPoint: BuyBuddyEndpoint.OrderCompletion,
             parameters: ["sale_id" : orderId,
                          "hitag_release_params" : ["hitags" : hitagValidations]],
             success: success,
             error: error)
        
    }
    
    
    func updateHitagCompletion(orderId: Int,
                      compileId:String,
                       success: @escaping  (SuccessHandler<HitagValidationResponse>),
                       error: @escaping (ErrorHandler)) {
        
        call(endPoint: BuyBuddyEndpoint.HitagCompletionUpdate,
             parameters: ["sale_id" : orderId,
                          "hitag_id" : compileId,
                          "compile_id" : compileId,
                          "hitag_completion" : ["status":1]],
             
             success: success,
             error: error)
        
    }
 
    func retryIncompleteOrder(success: @escaping  (SuccessHandler<IncompleteOrderResponse>),
                               error: @escaping (ErrorHandler)) {
        
        call(endPoint: BuyBuddyEndpoint.HitagIncompleteOrder,
             parameters: [:],
             
             success: success,
             error: error)
    }
    
    public func getJwt(accessToken: String,
                        success: @escaping  (SuccessHandler<BuyBuddyUserJwt>),
                        error: @escaping (ErrorHandler)) {
        
        call(endPoint: BuyBuddyEndpoint.GetJwt,
             parameters: ["passphrase_submission" : ["passkey": accessToken]],
             success: success,
             error: error)
    }
}


