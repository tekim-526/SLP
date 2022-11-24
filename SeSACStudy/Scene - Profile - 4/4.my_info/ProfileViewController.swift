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
        makeNavigationUI()
        navigationItem.title = "내정보"
        profileView.collectionView.delegate = self
        setDataSource()
        
    }
    
    private func setDataSource() {
        let cellRegisteration = UICollectionView.CellRegistration<ProfileViewCell, MyInfoList> { cell, indexPath, item in

            cell.imageView.image = item.image
            cell.label.text = item.title
            
            
        }
        datasource = UICollectionViewDiffableDataSource(collectionView: profileView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
        let header = UICollectionView.SupplementaryRegistration<ProfileHeaderView>(elementKind: "header") { [weak self] supplementaryView, elementKind, indexPath in
            supplementaryView.label.text = UserDefaults.standard.string(forKey: "nick")
            supplementaryView.imageView.image = UIImage(named: "sesac_face_1-1")
            supplementaryView.button.addTarget(self, action: #selector(self?.headerTapped), for: .touchUpInside)
        }
        
        datasource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            let header = collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
            return header
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, MyInfoList>()
        snapshot.appendSections([0])
        
        snapshot.appendItems(list)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    @objc func headerTapped() {
        let manageInfoVC = ManageInfoViewController()
        view.isUserInteractionEnabled = false
        TokenManager.shared.getIdToken { id in
            UserAPIManager.shared.login(idtoken: id) { [weak self] data, bool, error in
                guard let data = data else { return }
                manageInfoVC.data = data
                self?.navigationController?.pushViewController(manageInfoVC, animated: true)
                self?.view.isUserInteractionEnabled = true
            }
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate {
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexpath: \(indexPath)")
    }

}



struct MyInfoList: Hashable {
    let uuid = UUID()
    let title: String
    let image: UIImage?
}

