//
//  UdacityConstants.swift
//  OnTheMapV1P0A
//
//  Created by Farhan Qazi on 1/22/19.
//

import Foundation
import UIKit

extension UdacityClient {
    
    struct Constants {
        static let UdacityBaseURL: String = "https://www.udacity.com/api/"
        static var UdacityLoginOccured: Bool = false
    }
    
    struct Methods {
        static let Session = "session"
        static let User = "users/"
    }
    
    struct JSONRequestKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct JSONResponseKeys {
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        static let Session = "session"
        static let ID = "id"
        static let Expiration = "expiration"
        static let User = "user"
        static let FirstName =  "first_name"
        static let LastName = "last_name"
    }
    
    struct ParameterKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        static let Facebook = "facebook_mobile"
        static let AccessToken = "access_token"
    }
    
    struct LoginData {
        static var username = ""
        static var password = ""
        static var uniqueKey = ""
    }
}

