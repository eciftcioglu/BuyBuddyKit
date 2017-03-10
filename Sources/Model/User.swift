import Foundation

public class User {
    internal(set) public var username: String?
    internal(set) public var firstName: String?
    internal(set) public var lastName: String?
    internal(set) public var emailAssignment: EmailAssignment?

    public func fullName() throws -> String {
        guard let firstNameValue = firstName, let lastNameValue = lastName else {
            throw PersonalInformationNotAvailableError()
        }
        
        return firstNameValue + " " + lastNameValue
    }
    
    public func emailAddress() throws -> String {
        guard let emailAssignmentValue = emailAssignment else {
            throw EmailAssignmentNotAvailableError()
        }
        
        return emailAssignmentValue.emailAddress
    }
}
