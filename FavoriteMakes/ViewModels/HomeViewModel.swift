//
//  HomeViewModel.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 31/05/2022.
//

import SwiftUI



@MainActor
final class HomeViewModel: ObservableObject {
    
    private let userProvider: UserProvider
    private let brandsProvider: BrandsProvider
    @Published private var favoriteBrandsTask: TaskStatus<[Brand], Error>? {
        willSet {
            guard case let .inProgress(previousTask) = favoriteBrandsTask else { return }
            guard !previousTask.isCancelled else { return }
            previousTask.cancel()
        }
    }
    var isLoadingFavoriteBrands: Bool {
        guard case .inProgress = favoriteBrandsTask else { return false }
        return true
    }
    var favoriteBrandsTaskError: Error? {
        guard case let .failed(error) = favoriteBrandsTask else { return nil }
        return error
    }
    var favoriteBrands: [Brand] {
        guard case let .fetched(brands) = favoriteBrandsTask else { return [] }
        return brands.sorted { $0.name < $1.name }
    }
    
    init(userProvider: UserProvider = UserFetcher(),
         brandsProvider: BrandsProvider = BrandsFetcher()) {
        self.userProvider = userProvider
        self.brandsProvider = brandsProvider
    }
    
    func loadFavoriteBrands() async {
        let task: Task<[Brand], Error> = .detached { [weak self] in
            guard let user = try await self?.userProvider.currentUser
            else { throw AppError.referenceRemovedFromMemory }
            
            guard let brandsProvider = self?.brandsProvider
            else { throw AppError.referenceRemovedFromMemory }
            
            if user.isAnonymous {
                return try brandsProvider.localFavoriteBrands(of: user)
            }
            return try await brandsProvider.remoteFavoriteBrands(of: user)
        }
        
        favoriteBrandsTask = .inProgress(task)
        do { favoriteBrandsTask = .fetched(try await task.value) }
        catch { favoriteBrandsTask = .failed(error) }
    }
    
    func set(favorite brands: [Brand]) {
        favoriteBrandsTask = .fetched(brands)
    }
    
}
