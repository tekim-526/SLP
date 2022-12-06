//
//  UIDiffableDatasource+Extensions.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/28.
//

import UIKit

extension UICollectionViewDiffableDataSource {
    func refresh(completion: (() -> Void)? = nil) {
        self.apply(self.snapshot(), animatingDifferences: true, completion: completion)
    }
}
