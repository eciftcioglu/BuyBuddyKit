import Foundation
import Alamofire

public class PassphraseFactory {
    var factorizedPassphrasesCount: UInt16 = 0
    public var delegate: PassphraseFactoryDelegate!
    
    public init(delegate: PassphraseFactoryDelegate?) {
        self.delegate = delegate
    }
    
    public func createPassphrase(withCredentials credentials: Credentials) {
        var statusCode: Int = 0
        Alamofire.request("http://localhost:4000/api/passphrases/",
                          method: .post,
                          parameters: ["credentials": ["email":"test@mail.com", "password": "super_cow_powers"]],
                          encoding: JSONEncoding.default)
        .response { response in
            statusCode = (response.response?.statusCode)!
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            print("Status Code: \(String(describing: statusCode))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")

            }
        }
    }
}
