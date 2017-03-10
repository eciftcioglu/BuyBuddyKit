import Foundation
import Alamofire

public class PassphraseFactory {
    var factorizedPassphrasesCount: UInt16 = 0
    public var delegate: PassphraseFactoryDelegate!
    
    public init(delegate: PassphraseFactoryDelegate?) {
        self.delegate = delegate
    }
    
    public func createPassphrase(withCredentials credentials: Credentials) {
        Alamofire.request("http://localhost:4000/api/passphrases/",
                          method: .post,
                          parameters: ["credentials": ["email":"test@mail.com", "password": "super_cow_powers"]],
                          encoding: JSONEncoding.default)
        .response { response in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
        }
    }
}
