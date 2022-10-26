//
//  SimpleCollectionViewController.swift
//  SeSAC2Day72
//
//  Created by Y on 2022/10/18.
//

import UIKit

//private let reuseIdentifier = "Cell"

class User: Hashable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id = UUID().uuidString
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
}

class SimpleCollectionViewController: UICollectionViewController {

   // var list = ["닭곰탕", "삼계탕", "돌기름김", "삼분카레", "콘소메 치킨"]
    
    var list =  [
        User(name: "뽀로로", age: 3),
        User(name: "에디", age: 13),
        User(name: "해리포터", age: 33),
        User(name: "도라에몽", age: 5)
    ]
    
    //cellforitemat 이전에 생성해야함.
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //layout 설정 (extension에 함수 옮겨줬음)
        collectionView.collectionViewLayout = createLayout()
        
        //컬렉션뷰 스타일 (컬렉션뷰 x) 셀이 생성될때마다 실행
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
//            var content = cell.defaultContentConfiguration()
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .red
            
            content.secondaryText = "\(itemIdentifier.age)살"
            
            //secondary text 위치
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 20
            
     //       content.image = indexPath.item < 3 ? UIImage(systemName: "person.fill") : UIImage(systemName: "person")
            content.image = itemIdentifier.age < 8 ? UIImage(systemName: "person.fill") : UIImage(systemName: "person")
    
            content.imageProperties.tintColor = .brown

            print("setup")// 셀 각각 호출
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .lightGray
            backgroundConfig.cornerRadius = 10
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .systemPink
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier                                                     )
            
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, User>()
        snapShot.appendSections([0])
        snapShot.appendItems(list)
        dataSource.apply(snapShot)
        
        
    }
    
}
extension SimpleCollectionViewController {
    private func createLayout() -> UICollectionViewLayout {
        //14+ 부터 컬렉션뷰를 테이블뷰스타일로 사용가능 listConfiguration
        //sidebar style = 아이패드용
        //appearance style 플레인하면 각셀 테두리 변경가능
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        //뷰자체
        configuration.showsSeparators = false
        configuration.backgroundColor = .brown
        
        //tableview lista처럼 레이아웃쓰겠다.
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
