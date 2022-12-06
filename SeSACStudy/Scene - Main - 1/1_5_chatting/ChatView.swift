//
//  ChatView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/29.
//

import UIKit

class ChatView: BaseView {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .gray1
        tv.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        
        return tv
    }()
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "SendButton"), for: .normal)
        return button
    }()

    lazy var sendView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .gray1
        view.addSubview(textView)
        view.addSubview(sendButton)
        return view
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setupUI() {
        [collectionView, sendView].forEach { addSubview($0) }
    }
    
    override func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(sendView.snp.top)
        }
        
        sendView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(52)
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.equalTo(sendView.safeAreaLayoutGuide).offset(12)
            make.top.equalTo(sendView.snp.top).offset(8)
            make.height.greaterThanOrEqualTo(28)
            
            make.trailing.equalTo(sendButton.snp.leading).offset(-12)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(sendView.safeAreaLayoutGuide)
            make.trailing.equalTo(sendView.safeAreaLayoutGuide).offset(-14)
            make.verticalEdges.equalTo(sendView.safeAreaLayoutGuide).inset(16)
        }
        
        
    }
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(56))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "chatHeader", alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
}
