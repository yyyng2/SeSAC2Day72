//
//  DiffableViewModel.swift
//  SeSAC2Day72
//
//  Created by Y on 2022/10/20.
//

import Foundation

import RxSwift

enum SearchError: Error {
    case noPhoto
    case ServerError
}

class DiffableViewModel {
    
//    var photoList: CObservable<SearchPhoto> = CObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    
    var photoList = PublishSubject<SearchPhoto>()
    
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { [weak self] photo, statusCode, error in
            guard let statusCode = statusCode, statusCode == 200 else {
                self?.photoList.onError(SearchError.ServerError)
                return
            }
            guard let photo = photo else {
                self?.photoList.onError(SearchError.noPhoto)
                return
            }
            
//            self.photoList.value = photo
            self?.photoList.onNext(photo)
        }
    }
}
