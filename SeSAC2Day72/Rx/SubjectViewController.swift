//
//  SubjectViewController.swift
//  SeSAC2Day72
//
//  Created by Y on 2022/10/25.
//

import UIKit

import RxSwift
import RxCocoa

class SubjectViewController: UIViewController {
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    
    @IBOutlet weak var newAddButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()

    let publish = PublishSubject<Int>() //초기값이 없는 빈상태
    
    let behavior = BehaviorSubject(value: 100 ) //초기값이 있다
    
    let replay = ReplaySubject<Int>.create(bufferSize: 3) // bufferSize에 작성된 이벤트 수 만큼 메모리에서 이벤트를 가지고 있다가 Subscribe 직후 한번에 이벤트 전달
    
    let async = AsyncSubject<Int>() //초기값없이 가능
    
    //variable = 안씀 옛날 rx
    
    let viewModel = SubjectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        publishSubject()
//        behaviorSubject()
//        replaySubject()
//        asyncSubject()
        
        let input = SubjectViewModel.Input(addTap: addButton.rx.tap, resetTap: resetButton.rx.tap, newTap: newAddButton.rx.tap, searchText: searchBar.rx.text)
        
        let output = viewModel.transform(input: input)
        
        output.list
            .drive(tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self))  { (row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
            }
            .disposed(by: disposeBag)
        
        output.addTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
        output.resetTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
        output.newTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
        
        output.searchText
            .withUnretained(self)
            .subscribe { (vc, value) in
                print("=======\(value)")
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposeBag)
        
        
    //    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        viewModel.list
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
            }
//            .bind(to: tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
//                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
//            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
        newAddButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
     
        searchBar.rx.text.orEmpty
            //같은 값을 받지 않음
          //  .distinctUntilChanged()
        
            .withUnretained(self) // weak self
        
            //서브스크라이브 지연
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        
            .subscribe { (vc, value) in
                print("=======\(value)")
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposeBag)
        
    }
    
  

}

extension SubjectViewController {
    func publishSubject() {
        
        //섭스크라이브 전이라 안됨
        publish.onNext(1)
        publish.onNext(2)
        
        publish
            .subscribe { value in
                print("publish \(value)")
            } onError: { error in
                print("publish \(error)")
            } onCompleted: {
                print("publish completed")
            } onDisposed: {
                print("publish disposed")
            }
            .disposed(by: disposeBag)

        //구독 후라 전달됨
        publish.onNext(3)
        publish.onNext(4)
        
        publish.on(.next(5))
        
        publish.onCompleted()
        
        //dispose 후 여서 안됨
        publish.onNext(6)
    }
    
    func behaviorSubject() {
        
        //구족전에 가장 최근값을 emit
        
        behavior.onNext(1)
        behavior.onNext(200)
        
        behavior
            .subscribe { value in
                print("behavior \(value)")
            } onError: { error in
                print("behavior \(error)")
            } onCompleted: {
                print("behavior completed")
            } onDisposed: {
                print("behavior disposed")
            }
            .disposed(by: disposeBag)

        //구독 후라 전달됨
        behavior.onNext(3)
        behavior.onNext(4)
        
        behavior.on(.next(5))
        
        behavior.onCompleted()
        
        //dispose 후 여서 안됨
        behavior.onNext(6)
    }

    func replaySubject() {
        
        //버퍼 사이즈 만큼 최근 값 전달
        
        replay.onNext(100)
        replay.onNext(200)
        replay.onNext(300)
        replay.onNext(400)
        replay.onNext(500)
        
        replay
            .subscribe { value in
                print("replay \(value)")
            } onError: { error in
                print("replay \(error)")
            } onCompleted: {
                print("replay completed")
            } onDisposed: {
                print("replay disposed")
            }
            .disposed(by: disposeBag)

        //구독 후라 전달됨
        replay.onNext(3)
        replay.onNext(4)
        
        replay.on(.next(5))
        
        replay.onCompleted()
        
        //dispose 후 여서 안됨
        replay.onNext(6)
    }
    
    func asyncSubject() {
//        async.onNext(100)
//        async.onNext(200)
//        async.onNext(300)
//        async.onNext(400)
//        async.onNext(500)
//        
//        async
//            .subscribe { value in
//                print("async \(value)")
//            } onError: { error in
//                print("async \(error)")
//            } onCompleted: {
//                print("async completed")
//            } onDisposed: {
//                print("async disposed")
//            }
//            .disposed(by: disposeBag)
//
//
//        async.onNext(3)
//        async.onNext(4)
//        
//        //complete 직전 전달, 컴플리트 없다면 전달 안함
//        async.on(.next(5))
//        
//        async.onCompleted()
//        
//        //dispose 후 여서 안됨
//        async.onNext(6)
    }
}
