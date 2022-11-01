//
//  ValidationViewController.swift
//  SeSAC2Day72
//
//  Created by Y on 2022/10/27.
//

import UIKit

import RxSwift
import RxCocoa

class ValidationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    let viewModel = ValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
     //   observableVSSubject()
    }
    
    func bind() {
        
        
        //After
        let input = ValidationViewModel.Input(text: nameTextField.rx.text, tap: stepButton.rx.tap)
    
        let output = viewModel.transform(input: input)
        
        output.text
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        output.validation
            .bind { _ in
                print("show alert")
            }
            .disposed(by: disposeBag)
        
        //Before
        viewModel.validTaxt // output
            .asDriver()
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = nameTextField.rx.text.orEmpty // input
            .map { $0.count >= 8 }
            .share() // Subject, Relay은 포함

        validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)

        validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        stepButton.rx.tap // input
            .bind { _ in
                print("show alert")
            }
            .disposed(by: disposeBag)
        
        //Stream, Sequence
//        let testA = stepButton.rx.tap
//            .map { "안녕하세요" }
//            .asDriver(onErrorJustReturn: "")
//        // .share()
//
//        testA
//            .drive(validationLabel.rx.text)
//         //   .bind(to: validationLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        testA
//            .drive(nameTextField.rx.text)
//         //   .bind(to: nameTextField.rx.text)
//            .disposed(by: disposeBag)
//
//        testA
//            .drive(stepButton.rx.title())
//          //  .bind(to: stepButton.rx.title())
//            .disposed(by: disposeBag)
        
//        stepButton.rx.tap
//            .subscribe { _ in
//                print("next")
//            } onDisposed: {
//                print("dispose")
//            }
//            .disposed(by: disposeBag)
        
        
    }
    
    func observableVSSubject() {
        //just , from 에 포함됨
        //Observer = 1:1 관계
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        // subject = stream 공유, 같은 값 출력
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
    }

}
