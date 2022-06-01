//
//  BrandsFetcherTest.swift
//  FavoriteMakesTests
//
//  Created by Hans Rietmann on 31/05/2022.
//

import Foundation
import FavoriteMakes


final class BrandsFetcherTest: BrandsProvider {
    
    
    var remoteBrandsResult: Result<[Brand], Error> = .success(.remoteDummies)
    var localFavoriteBrandsResult: Result<[Brand], Error> = .success(.localDummies)
    var remoteFavoriteBrandsResult: Result<[Brand], Error> = .success(.remoteDummies)
    var locallySaveFavoriteBrandsResult: Result<(), Error> = .success(())
    var remotellySaveFavoriteBrandeResult: Result<(), Error> = .success(())
    
    
    var remoteBrands: [Brand] {
        get async throws {
            try remoteBrandsResult.get()
        }
    }
    func localFavoriteBrands(of user: User) throws -> [Brand] {
        try localFavoriteBrandsResult.get()
    }
    func remoteFavoriteBrands(of user: User) async throws -> [Brand] {
        try remoteFavoriteBrandsResult.get()
    }
    func locallySave(favorite brands: [Brand], to user: User) throws {
        try locallySaveFavoriteBrandsResult.get()
    }
    func remotellySave(favorite brands: [Brand], to user: User) async throws {
        try remotellySaveFavoriteBrandeResult.get()
    }
    
    
}
