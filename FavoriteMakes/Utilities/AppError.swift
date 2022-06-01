//
//  AppError.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 31/05/2022.
//

import Foundation





struct AppError: LocalizedError {
    let title: String
    let message: String
    var errorDescription: String? { title }
    
    private init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    
    /// Transforms any error to a localized ``AppError``
    /// - Parameter error: error to transform
    /// - Returns: transformed localized error
    static func localize(error: Error) -> AppError {
        if let appError = error as? AppError { return appError }
        
        let defaultTitle = String(
            format: NSLocalizedString("AppError.genericError.title", comment: "Unknown error title")
        )
        if let localizedError = error as? LocalizedError {
            return .init(
                title: localizedError.errorDescription ?? defaultTitle,
                message: localizedError.failureReason ?? localizedError.localizedDescription
            )
        }
        
        let messageKey = NSLocalizedString("AppError.genericError.message", comment: "Unknown error message")
        let defaultMessage = String(format: messageKey, error.localizedDescription)
        return .init(title: defaultTitle, message: defaultMessage)
    }
    
    
    /// Creates a localized ``AppError`` for when a reference type was removed from memory before the task finishes.
    /// This error may be crytical for the user experience and should be handled by the developer!
    static var referenceRemovedFromMemory: AppError {
        .init(
            title: String(
                format: NSLocalizedString("AppError.referenceRemovedFromMemory.title", comment: "Memory error title")
            ),
            message: String(
                format: NSLocalizedString("AppError.referenceRemovedFromMemory.message", comment: "Memory error message")
            )
        )
    }
    
    
    /// Creates invalid original URL error
    /// - Parameter link: link to be shortened
    /// - Returns: localized error ``AppError``
    static func invalidOrginalURLLink(link: String) -> AppError {
        .init(
            title: String(
                format: NSLocalizedString("AppError.invalidOrginalURLLink.title", comment: "Invalid URL link error title")
            ),
            message: String(
                format: NSLocalizedString("AppError.invalidOrginalURLLink.message", comment: "Invalid URL link error message"),
                link
            )
        )
    }
}
