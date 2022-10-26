//
//  DiffableCollectionViewController.swift
//  SeSAC2Day72
//
//  Created by Y on 2022/10/19.
//

import UIKit

import Kingfisher
import RxSwift
import RxCocoa

class DiffableCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var disposeBag = DisposeBag()
    
    private var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    
                                                        //<Int(섹션), String(값타입)>
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    var viewModel = DiffableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        
        searchBar.delegate = self
        
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        collectionView.delegate = self
        
        bindData()
       

    }
    
    func bindData() {
        //bind위치 dataSource 이후로
//        viewModel.photoList.bind { photo in
//            //initial
//            var snapShot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
//            snapShot.appendSections([0])
//            snapShot.appendItems(photo.results)
//            self.dataSource.apply(snapShot)
//        }
        
        viewModel.photoList
            .withUnretained(self)
            .subscribe (onNext: { (vc, photo) in
                //initial
                var snapShot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
                snapShot.appendSections([0])
                snapShot.appendItems(photo.results)
                vc.dataSource.apply(snapShot)
            }, onError: { error in
                print("=========Error: \(error)")
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { (vc, value) in
                vc.viewModel.requestSearchPhoto(query: value)
            }
            .disposed(by: disposeBag)
        
    }
    

 

}

extension DiffableCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }

//        let alert = UIAlertController(title: item, message: "tapped!", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "okay", style: .default)
//        alert.addAction(ok)
//        present(alert, animated: true)
    }
}

extension DiffableCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        viewModel.requestSearchPhoto(query: searchBar.text!)
        
//        var snapShot = dataSource.snapshot()
//        snapShot.appendItems([searchBar.text!])
//        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

extension DiffableCollectionViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
     
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.likes)"
            
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)
                let data = try? Data(contentsOf: url!)
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!)
                    cell.contentConfiguration = content
                }
        
            }

//            content.secondaryText = "\(itemIdentifier.count)"

            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeColor = .brown
            background.strokeWidth = 2
            cell.backgroundConfiguration = background
            
        })
        
        //numberofitemsInSection,cellforItemAt
        //collectionView.datasource = self 없어도됨
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        

    }
}
