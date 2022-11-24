//
//  NearUserViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/21.
//

import UIKit

class NearUserViewController: BaseViewController {
    let nearUserView = NearUserView()
    
    var isExpanded = false
    var peopleData: GetNearPeopleData!
    
    var datasource: UICollectionViewDiffableDataSource<Int, UserInfoModel>!
    var cellDatasource: UICollectionViewDiffableDataSource<Int, String>!
    
    override func loadView() {
        view = nearUserView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearUserView.collectionView.delegate = self
        setDatasource()
        makeNavigationUI(title: "새싹 찾기", rightBarButtonItem: nil)

    }
    
    func setDatasource() {
        print(#function)
        let cellReg = UICollectionView.CellRegistration<NearUserCell, UserInfoModel> { cell, indexPath, itemIdentifier in
            self.setInsideCellCollectionViewDatasource(cell: cell, item: indexPath.item)
        }
        datasource = UICollectionViewDiffableDataSource(collectionView: nearUserView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellReg, for: indexPath, item: itemIdentifier)
            cell.label.text = itemIdentifier.nick
            cell.image.image = UIImage(named: "sesac_background_\(itemIdentifier.background + 1)")
            cell.characterImage.image = UIImage(named: "sesac_face_\(itemIdentifier.sesac + 1)")

            return cell
        }
      
        var snapshot = NSDiffableDataSourceSnapshot<Int, UserInfoModel>()
        snapshot.appendSections([0])
        for item in peopleData.fromQueueDB {
            snapshot.appendItems([
                UserInfoModel(background: item.background,
                              reviews: item.reviews,
                              nick: item.nick,
                              uid: item.uid,
                              studylist: item.studylist,
                              sesac: item.sesac,
                              gender: item.sesac)
            ], toSection: 0)
        }
       
        datasource.apply(snapshot)
    }
    
    func setInsideCellCollectionViewDatasource(cell: NearUserCell, item: Int) {
     
        let cellRegisteration = UICollectionView.CellRegistration<WriteStudyCell, String> {  cell, indexPath, itemIdentifier in
       
        }
        self.cellDatasource = UICollectionViewDiffableDataSource(collectionView: cell.collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            cell.button.setAttributedTitle(self?.makeAttributeTitle(title: itemIdentifier), for: .normal)
            cell.button.layer.borderColor = UIColor.gray2.cgColor
            cell.button.layer.borderWidth = 1
            cell.button.tintColor = .black
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        
        var studyItems = [String]()
        for studyItem in peopleData.fromQueueDB[item].studylist {
            studyItems.append(studyItem)
        }
        snapshot.appendItems(studyItems, toSection: 0)
        cellDatasource.apply(snapshot)
        
    }
    
 
    
    func makeAttributeTitle(title: String) -> NSAttributedString {
        let attr = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 14)!])
        return attr
    }
    
    
    
}

extension NearUserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NearUserCell else { return }
        
        if !cell.isExpanded {
            cell.isExpanded = true
            cell.stackView5.isHidden = false
            cell.stackView5.snp.remakeConstraints { make in
                make.top.equalTo(cell.clearView.snp.bottom)
                make.horizontalEdges.equalToSuperview().inset(32)
                make.bottom.equalToSuperview().inset(16)
            }
            
        } else {
            cell.isExpanded = false
            cell.stackView5.isHidden = true
            cell.stackView5.snp.remakeConstraints { make in
                make.top.equalTo(cell.clearView.snp.bottom)
                make.horizontalEdges.equalToSuperview().inset(32)
                make.height.equalTo(0)
                make.bottom.equalToSuperview()
            }
        }
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * 0.999 )
            cell.foldButton.transform = cell.isExpanded ? upsideDown : .identity
        }
        datasource.refresh()
        
    }
    
}

extension UICollectionViewDiffableDataSource {
    func refresh(completion: (() -> Void)? = nil) {
        self.apply(self.snapshot(), animatingDifferences: true, completion: completion)
    }
}
