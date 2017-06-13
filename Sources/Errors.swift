//
//  BuyBuddyApiError.swift
//  BuyBuddyKit
//
//  Created by Furkan on 5/17/17.
//
//

import Foundation

enum EmailAssignmentNotAvailableError: Error {
    case missing(String)
}

enum PersonalInformationNotAvailableError: Error {
    case missing(String)
}

