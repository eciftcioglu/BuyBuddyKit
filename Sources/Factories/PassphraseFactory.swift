import Foundation
import Alamofire

public class PassphraseFactory {
    var factorizedPassphrasesCount: UInt16 = 0
    public var delegate: PassphraseFactoryDelegate!
    
    public init(delegate: PassphraseFactoryDelegate?) {
        self.delegate = delegate
    }
    
    public func createPassphrase(withCredentials credentials: Credentials) {
        Alamofire.request("http://localhost:4000/api/passphrase/",
                          method: .post,
                          parameters: ["":""],
                          encoding: JSONEncoding.default)
        .responseJSON { response in
            print(response)
        }
    }
}
