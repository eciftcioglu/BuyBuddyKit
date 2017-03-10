import Foundation

public class Passphrase {
    private let passkey: String
    public let insertedAt: Date
    
    init(passkey: String, insertedAt: Date) {
        self.passkey = passkey
        self.insertedAt = insertedAt
    }
}
