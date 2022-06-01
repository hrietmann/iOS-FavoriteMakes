//
//  Brand.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 30/05/2022.
//

import Foundation



public struct Brand {
    
    public let id: UUID
    public let name: String
    public let iconURL: URL?
    public let iconName: String?
    
    fileprivate init(name: String, iconName: String) {
        self.id = UUID()
        self.name = name
        self.iconURL = nil
        self.iconName = iconName
    }
    
}



extension Brand: Identifiable, Equatable, Hashable, Codable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(iconURL)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    
}



extension Brand {
    
    
    static var Audi: Brand          = .init(name: "Audi", iconName: "Audi")
    static var BMW: Brand           = .init(name: "BMW", iconName: "BMW")
    static var Chrysler: Brand      = .init(name: "Chrysler", iconName: "Chrysler")
    static var Citroen: Brand       = .init(name: "Citroën", iconName: "Citroën")
    static var Ferrari: Brand       = .init(name: "Ferrari", iconName: "Ferrari")
    static var Lamborghini: Brand   = .init(name: "Lamborghini", iconName: "Lamborghini")
    static var Mercedes: Brand      = .init(name: "Mercedes", iconName: "Mercedes")
    static var Peugeot: Brand       = .init(name: "Peugeot", iconName: "Peugeot")
    static var Tesla: Brand         = .init(name: "Tesla", iconName: "Tesla")
    static var Toyota: Brand        = .init(name: "Toyota", iconName: "Toyota")
    
    
    public static var dummies: [Self] = [.Audi, .BMW, .Chrysler, .Citroen, .Ferrari, .Lamborghini, .Mercedes, .Peugeot, .Tesla, .Toyota]
    public static var localDummies: [Self] { .init(dummies[...3]) }
    public static var remoteDummies: [Self] { .init(dummies[4...]) }
    
    
}



extension Collection where Element == Brand {
    
    public static var dummies: [Element] { Brand.dummies }
    public static var localDummies: [Element] { Brand.localDummies }
    public static var remoteDummies: [Element] { Brand.remoteDummies }
    
}
