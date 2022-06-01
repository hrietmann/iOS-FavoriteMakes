//
//  BrandsFetcher.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 31/05/2022.
//

import Foundation



public protocol BrandsProvider {
    var remoteBrands: [Brand] { get async throws }
    func localFavoriteBrands(of user: User) throws -> [Brand]
    func remoteFavoriteBrands(of user: User) async throws -> [Brand]
    func locallySave(favorite brands: [Brand], to user: User) throws
    func remotellySave(favorite brands: [Brand], to user: User) async throws
}


final class BrandsFetcher: BrandsProvider {
    var remoteBrands: [Brand] {
        get async throws {
            // Should load from online API in the future...
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            return Brand.dummies
        }
    }
    func localFavoriteBrands(of user: User) throws -> [Brand] {
        // Should load from CodeData in the future...
        []
    }
    func remoteFavoriteBrands(of user: User) async throws -> [Brand] {
        // Should load from online API in the future...
        Brand.remoteDummies
    }
    func locallySave(favorite brands: [Brand], to user: User) throws {
        // Should load from CoreData/online API in the future...
        
    }
    func remotellySave(favorite brands: [Brand], to user: User) async throws {
        // Should load from online API in the future...
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
    }
}
