//
//  SubjectViewModel.swift
//  SeSAC2Day72
//
//  Created by Y on 2022/10/25.
//

import Foundation

import RxSwift

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel {
    var contactData = [
    Contact(name: "Jack", age: 23, number: "01012341234"),
    Contact(name: "Hue", age: 19, number: "01012341234"),
    Contact(name: "Real Jack", age: 25, number: "01012341234")
    ]
    
    var list = PublishSubject<[Contact]>()
    
    func fetchData() {
        list.onNext(contactData)
    }
    
    func resetData() {
        list.onNext([])
    }
    
    func newData() {
        let new = Contact(name: "Dummy", age: Int.random(in: 10...50), number: "0\(Int.random(in: 1000000000...1099999999))")
        contactData.append(new)
        list.onNext(contactData)
    }
    
    func filterData(query: String) {
        let result = query != "" ? contactData.filter { $0.name.contains(query)} : contactData
//        let result = contactData.filter{$0.name == query}
        list.onNext(result)
    }
}
