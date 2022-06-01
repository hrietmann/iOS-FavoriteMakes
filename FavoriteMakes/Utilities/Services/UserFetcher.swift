//
//  UserFetcher.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 31/05/2022.
//

import Foundation




public protocol UserProvider {
    var currentUser: User { get async throws }
}



final public class UserFetcher: UserProvider {
    
    public var currentUser: User {
        get async throws {
            // Should load from CodeData/Online API in the future...
            .dummyAnonymous
        }
    }
}
