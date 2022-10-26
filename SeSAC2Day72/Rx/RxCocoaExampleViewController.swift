//
//  RxCocoaExampleViewController.swift
//  SeSAC2Day72
//
//  Created by Y on 2022/10/24.
//

import UIKit

import RxCocoa
import RxSwift

class RxCocoaExampleViewController: UIViewController {
    @IBOutlet weak var simpleTableView: UITableView!
    
    @IBOutlet weak var simplePickerView: UIPickerView!
    
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    var disposeBag = DisposeBag()
    
    var nickname = Observable.just("Jack")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nickname
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.nickname = "HELLO"
        }
        
        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
    }
    
    //viewController 가 deinit되면 dispose됨
    //또는 dispatchBag()객체를 새롭게 넣어주거나 nil 할당 -> 예외 케이스 (root view에 인터벌이 있다면)
    deinit {
        print("RXCOCOAEXAMPLEVIEWCONTROLLER DEINIT")
    }
    
    func setOperator() {
        //5회만 반복해
//        Observable.repeatElement("Jack")
//            .take(5)
//            .subscribe { value in
//                print("repeatElement \(value)")
//            } onError: { error in
//                print("repeatElement \(error)")
//            } onCompleted: {
//                print("repeatElement completed")
//            } onDisposed: {
//                print("repeatElement disposed")
//            }
//            .disposed(by: disposeBag)
        
        //타이머?
       Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval \(value)")
            } onError: { error in
                print("interval \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
             .subscribe { value in
                 print("interval \(value)")
             } onError: { error in
                 print("interval \(error)")
             } onCompleted: {
                 print("interval completed")
             } onDisposed: {
                 print("interval disposed")
             }
             .disposed(by: disposeBag)
        
        //DisposeBag 리로스 해제 관리
            //1. 시퀀스 끝날때 but bind
            //2. class deinit 자동해제(bind)
            //3. dispose 직접 호출 -> dispose() 구독하는 것마다 별도로 관리해야해서 번거롭다
            //4. disposeBag을 새롭게 할당하거나 nil을 전달
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.disposeBag = DisposeBag()
////            intervalObservable.dispose()
////            intervalObservable2.dispose()
//        }
        
        
        
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just \(value)")
            } onError: { error in
                print("just \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        //just는 하나, of는 여러개 가변변수
        Observable.of(itemsA, itemsB)
            .subscribe { value in
                print("of \(value)")
            } onError: { error in
                print("of \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.from(itemsA)
            .subscribe { value in
                print("from \(value)")
            } onError: { error in
                print("from \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func setSign() {
        //텍스트필드(옵저버블) 레이블(옵저버,바인드)
        //orEmpty 옵셔널 바인딩
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "이름은 \(value1), 이메일 \(value2)입니다."
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        //stream 데이터의 흐름
        signName.rx.text.orEmpty
            .map { $0.count < 4 }
            //.bind(to: signEmail.rx.isHidden)
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .withUnretained(self) // [weak self]
            .subscribe(onNext: { vc, _ in
                vc.showAlert()
            })
//            .subscribe { [weak self] _ in
//                self?.showAlert()
//            }
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "buttonTapped", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "okay", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func setSwitch() {
        Observable.of(false) // just? of?
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
            .bind(to: simpleTableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
               cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map{ data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)

    }
    
    func setPickerView() {
        let items = Observable.just([
                "영화",
                "애니메이션",
                "드라마",
                "기타"
            ])
     
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map{ $0.description }
            .bind(to: simpleLabel.rx.text)
//            .subscribe(onNext: { value in
//                print(value)
//            })
            .disposed(by: disposeBag)
    }
  

}
