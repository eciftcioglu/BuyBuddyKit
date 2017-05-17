import Foundation

class BuyBuddyAuthentication {
    var token: String?
    var jwt: BuyBuddyUserJwt?
    
    init(token: String, jwt: BuyBuddyUserJwt) {
        self.token = token
        self.jwt = jwt
    }
}
