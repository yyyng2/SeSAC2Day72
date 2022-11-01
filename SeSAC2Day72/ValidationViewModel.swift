//
//  ValidationViewModel.swift
//  SeSAC2Day72
//
//  Created by Y on 2022/10/27.
//

import Foundation

import RxSwift
import RxCocoa

class ValidationViewModel {
    
    let validTaxt = BehaviorRelay(value: "닉네임은 최소 8자이상 필요합니다.")
    
    struct Input {
        let text: ControlProperty<String?> //nameTextField.rx.text
        let tap: ControlEvent<Void> //stepButton.rx.tap
    }
    
    struct Output {
        let validation: Observable<Bool> //text
        let tap: ControlEvent<Void> //stepButton.rx.tap
        let text: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let valid = input.text
            .orEmpty
            .map{ $0.count >= 8 }
            .share()
        let text = validTaxt.asDriver()
        
        return Output(validation: valid, tap: input.tap, text: text)
    }
    
}
