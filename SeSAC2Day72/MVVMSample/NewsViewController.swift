//
//  NewsViewController.swift
//  SeSAC2Day72
//
//  Created by Y on 2022/10/20.
//

import UIKit

import RxSwift
import RxCocoa

class NewsViewController: UIViewController {
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberTextField: UITextField!
    
    var disposeBag = DisposeBag()
    
    var viewModel = NewsViewModel()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        numberTextField.text = "3000"
        
        //
        configureHierarchy()
        configureDataSource()
        configureButtons()
        bindData()
        
    }
    
    func bindData() {
//        viewModel.pageNumber.bind { value in
//            self.numberTextField.text = value
//        }
//
//        viewModel.sampleNews.bind { item in
//            var snapShot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
//            snapShot.appendSections([0])
//            snapShot.appendItems(item)
//            self.dataSource.apply(snapShot, animatingDifferences: false)
//        }
        
        viewModel.sampleNews
            .withUnretained(self)
            .bind { (vc, item) in
                var snapShot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
                snapShot.appendSections([0])
                snapShot.appendItems(item)
                vc.dataSource.apply(snapShot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
        
        numberTextField.rx.text.orEmpty
            .withUnretained(self)
            .bind { (vc, text) in
                vc.viewModel.changePageNumberFormat(text: text)
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .bind { (vc, text) in
                vc.viewModel.resetSample()
            }
            .disposed(by: disposeBag)
        
        loadButton.rx.tap
            .withUnretained(self)
            .bind { (vc, text) in
                vc.viewModel.loadSample()
            }
            .disposed(by: disposeBag)
    }
    
    func configureButtons() {
//        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
//        numberTextField.rx.text.orEmpty
//            .withUnretained(self)
//            .subscribe { (vc, text) in
//                vc.viewModel.changePageNumberFormat(text: text)
//            }
//            .disposed(by: disposeBag)
//        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
//        resetButton.rx.tap
//            .withUnretained(self)
//            .subscribe { (vc, _) in
//                vc.viewModel.resetSample()
//            }
//            .disposed(by: disposeBag)
//        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
//        loadButton.rx.tap
//            .withUnretained(self)
//            .subscribe { (vc, _) in
//                vc.viewModel.loadSample()
//            }
//            .disposed(by: disposeBag)
    }
    
//    @objc func numberTextFieldChanged() {
//        guard let text = numberTextField.text else { return }
//        viewModel.changePageNumberFormat(text: text)
//    }
//
//    @objc func resetButtonTapped() {
//        viewModel.resetSample()
//    }
//
//    @objc func loadButtonTapped() {
//        viewModel.loadSample()
//    }
}

extension NewsViewController {
    func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
        snapShot.appendSections([0])
        snapShot.appendItems(News.items)
        dataSource.apply(snapShot, animatingDifferences: false)
        
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
  
}
