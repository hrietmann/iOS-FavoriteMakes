//
//  HomeViewModelTests.swift
//  FavoriteMakesTests
//
//  Created by Hans Rietmann on 31/05/2022.
//

import XCTest
@testable import FavoriteMakes



@MainActor
class HomeViewModelTests: XCTestCase {
    

    func test_successful_anonymousUser_loadFavoriteBrands() async throws {
        let userProvider = UserFetcherTest()
        userProvider.currentUserResult = .success(.dummyAnonymous)
        let localFavoriteBrands = [Brand].localDummies
        let brandsProvider = BrandsFetcherTest()
        brandsProvider.localFavoriteBrandsResult = .success(localFavoriteBrands)
        brandsProvider.remoteFavoriteBrandsResult = .success([])
        
        let sut = HomeViewModel(userProvider: userProvider, brandsProvider: brandsProvider)
        await sut.loadFavoriteBrands()
        
        XCTAssertEqual(sut.favoriteBrands, localFavoriteBrands)
        XCTAssertNil(sut.favoriteBrandsTaskError)
        XCTAssertFalse(sut.isLoadingFavoriteBrands)
    }
    
    func test_unsuccessful_anonymousUser_loadFavoriteBrands() async throws {
        let userProvider = UserFetcherTest()
        userProvider.currentUserResult = .success(.dummyAnonymous)
        let error = AppError.invalidOrginalURLLink(link: "test")
        let brandsProvider = BrandsFetcherTest()
        brandsProvider.localFavoriteBrandsResult = .failure(error)
        
        let sut = HomeViewModel(userProvider: userProvider, brandsProvider: brandsProvider)
        await sut.loadFavoriteBrands()
        
        XCTAssertEqual(sut.favoriteBrandsTaskError?.localizedDescription, error.localizedDescription)
        XCTAssertTrue(sut.favoriteBrands.isEmpty)
        XCTAssertFalse(sut.isLoadingFavoriteBrands)
    }
    
    func test_successful_identifiedUser_loadFavoriteBrands() async throws {
        let userProvider = UserFetcherTest()
        userProvider.currentUserResult = .success(.dummy)
        let remoteFavoriteBrands = [Brand].localDummies
        let brandsProvider = BrandsFetcherTest()
        brandsProvider.localFavoriteBrandsResult = .success([])
        brandsProvider.remoteFavoriteBrandsResult = .success(remoteFavoriteBrands)
        
        let sut = HomeViewModel(userProvider: userProvider, brandsProvider: brandsProvider)
        await sut.loadFavoriteBrands()
        
        XCTAssertEqual(sut.favoriteBrands, remoteFavoriteBrands)
        XCTAssertNil(sut.favoriteBrandsTaskError)
        XCTAssertFalse(sut.isLoadingFavoriteBrands)
    }
    
    func test_unsuccessful_identifiedUser_loadFavoriteBrands() async throws {
        let userProvider = UserFetcherTest()
        userProvider.currentUserResult = .success(.dummy)
        let error = AppError.invalidOrginalURLLink(link: "test")
        let brandsProvider = BrandsFetcherTest()
        brandsProvider.remoteFavoriteBrandsResult = .failure(error)
        
        let sut = HomeViewModel(userProvider: userProvider, brandsProvider: brandsProvider)
        await sut.loadFavoriteBrands()
        
        XCTAssertEqual(sut.favoriteBrandsTaskError?.localizedDescription, error.localizedDescription)
        XCTAssertTrue(sut.favoriteBrands.isEmpty)
        XCTAssertFalse(sut.isLoadingFavoriteBrands)
    }

}
