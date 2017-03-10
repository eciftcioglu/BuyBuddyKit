import Foundation

public struct EmailAssignment {
    public let emailAddress: String
    public let insertedAt: Date
    
    init(emailAddress: String, insertedAt: Date) {
        self.emailAddress = emailAddress
        self.insertedAt = insertedAt
    }
}
