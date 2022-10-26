//
//  SubscribeViewController.swift
//  SeSAC2Day72
//
//  Created by Y on 2022/10/26.
//

import UIKit

import RxSwift
import RxCocoa

class SubscribeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var label: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1
        button.rx.tap
            .subscribe { [weak self] _ in
                self?.label.text = "안녕, 반가워"
            }
            .disposed(by: disposeBag)
        
        //2
        button.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕, 반가워"
            }
            .disposed(by: disposeBag)
        
        //3. 네트워크 통신이나 파일 다운로드 등 백그라운드 작업
        button.rx.tap
            .observe(on: MainScheduler.instance) // 다른 쓰레드로 동작하게 변경
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕, 반가워"
            }
            .disposed(by: disposeBag)
        
        //4. bind
        button.rx.tap
            .withUnretained(self)
            
            // subscribe && mainSchedular O, error X -> 런타임에러 발생
            .bind { (vc, _) in
                vc.label.text = "안녕, 반가워"
            }
            .disposed(by: disposeBag)
        
        //5. operator로 데이터의 stream 조작
        button.rx.tap
            .map { "안녕 반가워" }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        //6. driver traits: bind + stream 공유(리소스 낭비 방지, share() )
        button.rx.tap
            .map {"안녕 반가워"}
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
        
    }
    

  

}
