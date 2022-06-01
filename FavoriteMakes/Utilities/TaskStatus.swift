//
//  TaskStatus.swift
//  FavoriteMakes
//
//  Created by Hans Rietmann on 31/05/2022.
//

import Foundation




/// Specifies status about a asynchronous task to be stored and referenced more easely.
enum TaskStatus<Success, Failure> where Failure: Error {
    
   case inProgress(Task<Success, Failure>)
   case failed(Failure)
   case fetched(Success)
    
}
