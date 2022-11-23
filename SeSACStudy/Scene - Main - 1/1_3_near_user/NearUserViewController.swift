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
    
    
    var datasource: UICollectionViewDiffableDataSource<Int, String>!
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
        let cellReg = UICollectionView.CellRegistration<NearUserCell, String> { cell, indexPath, itemIdentifier in
            
        }
        datasource = UICollectionViewDiffableDataSource(collectionView: nearUserView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellReg, for: indexPath, item: itemIdentifier)
            cell.label.text = itemIdentifier
            return cell
        }
      
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(["asd", "ㅁㄴㅇㅁㄴ", "asda"])
        snapshot.appendSections([1])
        snapshot.appendItems(["!23", "Asdasd"])
        datasource.apply(snapshot)
    }
    
    
}

extension NearUserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NearUserCell else { return }
        
        if !isExpanded {
            isExpanded = true
            cell.stackView5.isHidden = false
            cell.stackView5.snp.remakeConstraints { make in
                make.top.equalTo(cell.clearView.snp.bottom)
                make.horizontalEdges.equalToSuperview().inset(32)
                make.bottom.equalToSuperview().inset(16)
            }
            
        } else {
            isExpanded = false
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
            cell.foldButton.transform = self.isExpanded ? upsideDown : .identity
        }
        datasource.refresh()
    }
    
}

extension UICollectionViewDiffableDataSource {
    func refresh(completion: (() -> Void)? = nil) {
        self.apply(self.snapshot(), animatingDifferences: true, completion: completion)
    }
}
