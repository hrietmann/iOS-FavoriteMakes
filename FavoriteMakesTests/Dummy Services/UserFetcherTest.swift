//
//  UserFetcherTest.swift
//  FavoriteMakesTests
//
//  Created by Hans Rietmann on 31/05/2022.
//

import Foundation
import FavoriteMakes


final class UserFetcherTest: UserProvider {
    var currentUserResult: Result<User, Error> = .success(.dummyAnonymous)
    var currentUser: User {
        get async throws { try currentUserResult.get() }
    }
}
