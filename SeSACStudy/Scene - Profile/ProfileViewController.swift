//
//  ProfileViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/14.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    let profileView = ProfileView()
    var datasource: UICollectionViewDiffableDataSource<Int, MyInfoList>!
    let list = [
        MyInfoList(title: UserDefaults.standard.string(forKey: "nick") ?? "", image: UIImage(named: "sesac_face_1-1")!),
        MyInfoList(title: "공지사항", image: UIImage(named: "notice")),
        MyInfoList(title: "자주 묻는 질문", image: UIImage(named: "faq")),
        MyInfoList(title: "1:1 문의", image: UIImage(named: "qna")),
        MyInfoList(title: "알림 설정", image: UIImage(named: "setting_alarm")),
        MyInfoList(title: "이용약관", image: UIImage(named: "permit"))
    ]
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "내정보"
        
        setDataSource()
        
    }
    
    private func setDataSource() {
        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, MyInfoList> { cell, indexPath, item in
            var content = UIListContentConfiguration.valueCell()
            DispatchQueue.main.async {
                content.attributedText = NSAttributedString(string: item.title, attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 16)!])
                content.image = item.image
                content.imageProperties.cornerRadius = 24
                content.imageProperties.maximumSize = CGSize(width: 48, height: 48)
                
                cell.contentConfiguration = content
            }
            
        }
        datasource = UICollectionViewDiffableDataSource(collectionView: profileView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
        
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, MyInfoList>()
        snapshot.appendSections([0])
        
        snapshot.appendItems(list)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
}
struct MyInfoList: Hashable {
    let uuid = UUID()
    let title: String
    let image: UIImage?
}


