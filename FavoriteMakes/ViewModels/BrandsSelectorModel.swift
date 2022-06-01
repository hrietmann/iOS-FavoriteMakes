//
//  BrandsSelectorModel.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 31/05/2022.
//

import SwiftUI




@MainActor
final class BrandsSelectorModel: ObservableObject {
    
    
    private let userProvider: UserProvider
    private let brandsProvider: BrandsProvider
    private let completion: ([Brand]) -> ()
    private let favoriteBrands: [Brand]
    @Published var selected: [Brand]
    @Published private var loadRemoteBrandsTask: TaskStatus<[Brand], Error>? {
        didSet {
            if case .inProgress = loadRemoteBrandsTask { isLoadingBrands = true }
            else { isLoadingBrands = false }
        }
    }
    @Published private(set) var isLoadingBrands = false
    var brandsLoadError: Error? {
        guard case let .failed(error) = loadRemoteBrandsTask else { return nil }
        return error
    }
    var loadedBrands: [Brand] {
        guard case let .fetched(brands) = loadRemoteBrandsTask else { return [] }
        return brands
    }
    @Published private var saveSelectedBrandsTask: TaskStatus<(), Error>? {
        didSet {
            if case .inProgress = saveSelectedBrandsTask { isSavingFavorites = true }
            else { isSavingFavorites = false }
        }
    }
    @Published private(set) var isSavingFavorites = false
    var saveError: Error? {
        guard case let .failed(error) = saveSelectedBrandsTask else { return nil }
        return error
    }
    var isSaveSuccessful: Bool {
        guard case .fetched = saveSelectedBrandsTask else { return false }
        return true
    }
    var anyError: AppError? {
        if let error = brandsLoadError as? AppError { return error }
        if let error = saveError as? AppError { return error }
        if let error = brandsLoadError ?? saveError { return .localize(error: error) }
        return nil
    }
    var saveButtonTitle: String? {
        let addedCount = selected.filter { !favoriteBrands.contains($0) }.count
        let removedCount = favoriteBrands.filter { !selected.contains($0) }.count
        if addedCount == 0, removedCount == 0 { return nil }
        if addedCount != 0, removedCount != 0 { return "Save" }
        if addedCount != 0 { return "Add \(addedCount)" }
        if removedCount != 0 { return "Remove \(removedCount)" }
        return "Save"
    }
    var saveButtonColor: Color {
        let addedCount = selected.filter { !favoriteBrands.contains($0) }.count
        let removedCount = favoriteBrands.filter { !selected.contains($0) }.count
        if removedCount != 0, addedCount == 0 { return Color.red }
        return Color.accentColor
    }
    
    
    init(favorite brands: [Brand],
         userProvider: UserProvider = UserFetcher(),
         brandsProvider: BrandsProvider = BrandsFetcher(),
         completion: @escaping ([Brand]) -> ()) {
        self.userProvider = userProvider
        self.brandsProvider = brandsProvider
        self.favoriteBrands = brands
        self.selected = brands
        self.completion = completion
    }
    
    
    func loadRemoteBrands() async {
        let task: Task<[Brand], Error> = .detached { [weak self] in
            guard let brands = try await self?.brandsProvider.remoteBrands
            else { throw AppError.referenceRemovedFromMemory }
            return brands
        }
        
        loadRemoteBrandsTask = .inProgress(task)
        do { loadRemoteBrandsTask = .fetched(try await task.value) }
        catch { loadRemoteBrandsTask = .failed(error) }
    }
    
    
    func updateSelectedBrands() async {
        let task: Task<(), Error> = .detached { [weak self] in
            guard let model = self
            else { throw AppError.referenceRemovedFromMemory }
            
            let (user, selected) = try await (model.userProvider.currentUser, model.selected)
            
            guard let brandsProvider = self?.brandsProvider
            else { throw AppError.referenceRemovedFromMemory }
            let favoriteBrands = Array<Brand>.init(selected)
            
            if user.isAnonymous {
                try brandsProvider.locallySave(favorite: favoriteBrands, to: user)
                return
            }
            try await brandsProvider.remotellySave(favorite: favoriteBrands, to: user)
        }
        
        saveSelectedBrandsTask = .inProgress(task)
        do {
            try await task.value
            saveSelectedBrandsTask = .fetched(())
            completion(.init(selected))
        } catch { saveSelectedBrandsTask = .failed(error) }
    }
    
    
}
