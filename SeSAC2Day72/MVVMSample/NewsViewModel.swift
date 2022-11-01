//
//  NewsViewModel.swift
//  SeSAC2Day72
//
//  Created by Y on 2022/10/20.
//

import Foundation

import RxSwift
import RxCocoa

class NewsViewModel {
    //var pageNumber: CObservable<String> = CObservable("3000")
    var pageNumber = BehaviorSubject<String>(value: "3,000")
    
//    var sampleNews = BehaviorSubject(value: News.items)
    var sampleNews = BehaviorRelay(value: News.items)
    
    
    
    func changePageNumberFormat(text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        
        let result = numberFormatter.string(for: number)!
        
        //pageNumber.value = result
        pageNumber.onNext(result)
    }
    
    // Subject -> onNext , Relay -> accept
    func resetSample() {
      //  sampleNews.onNext([])
        sampleNews.accept([])
    }
    
    func loadSample() {
    //    sampleNews.onNext(News.items)
        sampleNews.accept(News.items)
    }
}
