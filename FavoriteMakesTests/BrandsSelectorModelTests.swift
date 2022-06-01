//
//  BrandsSelectorModelTests.swift
//  FavoriteMakesTests
//
//  Created by Hans Rietmann on 31/05/2022.
//

import XCTest
@testable import FavoriteMakes


/// - remoteBrands ✅
/// - localFavoriteBrands(ofUser) 
/// - remoteFavoriteBrands(favoriteBrands, ofUser)
/// - locallySave(favoriteBrands, toUser)
/// - remotellySave(favoriteBrands, toUser)


@MainActor
class BrandsSelectorModelTests: XCTestCase {

    func test_successful_loadRemoteBrands() async throws {
        let remoteBrands = [Brand].dummies
        let userProvider = UserFetcherTest()
        let brandsProvider = BrandsFetcherTest()
        brandsProvider.remoteBrandsResult = .success(remoteBrands)
        
        let sut = BrandsSelectorModel(favorite: [], userProvider: userProvider, brandsProvider: brandsProvider) { _ in }
        await sut.loadRemoteBrands()
        
        XCTAssertEqual(sut.loadedBrands, remoteBrands)
        XCTAssertNil(sut.brandsLoadError)
        XCTAssertFalse(sut.isLoadingBrands)
    }
    
    func test_successful_updateSelectedBrands() async throws {
        
    }

}
