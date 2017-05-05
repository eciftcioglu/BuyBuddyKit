//
//  User.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 06/04/2017.
//
//
import Foundation
import Alamofire

public class User {
    internal(set) public var username: String?
    internal(set) public var firstName: String?
    internal(set) public var lastName: String?
    internal(set) public var emailAssignment: EmailAssignment?
    
    
    required public init?(json: [String:Any]) throws{
        guard
            let username = json["username"] as? String,
            let firstName = json["firstName"] as? String,
            let lastName = json["lastName"] as? String,
            let emailAssignment = json["emailAssignment"] as? EmailAssignment
            else { return nil }
        
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.emailAssignment = emailAssignment
    }

    public func fullName() throws -> String {
        guard let firstNameValue = firstName, let lastNameValue = lastName else {
                throw PersonalInformationNotAvailableError.missing("name or lastname")
        }
        
        return firstNameValue + " " + lastNameValue
    }
    
    public func emailAddress() throws -> String {
        guard let emailAssignmentValue = emailAssignment else {
            throw EmailAssignmentNotAvailableError.missing("email Address")
        }
        
        return emailAssignmentValue.emailAddress
    }
}
