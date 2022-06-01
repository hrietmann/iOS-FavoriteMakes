//
//  User.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 31/05/2022.
//

import Foundation



public struct User {
    public let id: UUID
    public let username: String
    public let profileImageURL: URL?
    public let isAnonymous: Bool
}

extension User: Identifiable, Equatable, Hashable, Codable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(username)
        hasher.combine(profileImageURL)
        hasher.combine(isAnonymous)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
}

extension User {
    
    public static var dummy = User(id: UUID(),
                            username: "Hans Rietmann",
                            profileImageURL: .init(string: "https://pbs.twimg.com/profile_images/1263375874985992195/TPhY9iGp_400x400.png"),
                            isAnonymous: false)
    
    public static var dummyAnonymous = User(id: UUID(), username: "Dummy user", profileImageURL: nil, isAnonymous: true)
    
}
