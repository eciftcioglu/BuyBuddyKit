//
//  BuyBuddyJwtAdapter.swift
//  BuyBuddyKit
//
//  Created by Furkan on 5/16/17.
//
//

import Foundation
import Alamofire
import ObjectMapper

class BuyBuddyJwtAdapter: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ jwt: BuyBuddyUserJwt?) -> Void
    private var jwt: BuyBuddyUserJwt?
    private var accessToken: String?
    private var sessionManager: SessionManager!
    private var tokenDelegate: BuyBuddyInvalidTokenDelegate?
    private let lock = NSLock()
    
    init(accessToken: String!, jwt: BuyBuddyUserJwt?, sessionManager: SessionManager, tokenDelegate: BuyBuddyInvalidTokenDelegate?) {
        self.accessToken = accessToken
        self.jwt = jwt
        self.sessionManager = sessionManager
    }
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock(); defer { lock.unlock() }

        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                
                refreshJwt { [weak self] succeeded, jwt in
                    guard let strongSelf = self else { return }
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    if let jwt = jwt {
                        strongSelf.jwt = jwt
                        Utilities.saveToUd(key: "user_jwt", value: jwt.toDict())
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
        
        
    }
    
    private func refreshJwt(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true

        BuyBuddyApi.sharedInstance.getJwt(accessToken: accessToken!, success: {
           [weak self] (jwtResponse: BuyBuddyObject<BuyBuddyUserJwt>, httpURLResponse) in
            
            guard let strongSelf = self else { return }
            BuyBuddyUserJwt.setCurrentJwt(jwt: jwtResponse.data!)
            completion(true, jwtResponse.data!)
            strongSelf.isRefreshing = false
        
        }) {[weak self] (err, httpURLResponse) in
            
            completion(false, nil)
            guard let strongSelf = self else { return }
            strongSelf.isRefreshing = false
        }
        
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if jwt != nil{
            if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(BuyBuddyApi.getBaseUrl) {
                urlRequest.setValue("Bearer " + jwt!.jwt, forHTTPHeaderField: "Authorization")
            }
        }
        
        return urlRequest
    }
}
