//
//  NearUserViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/21.
//

import UIKit

class BaseRequestAndAccpetViewController: BaseViewController {
   
    var isRequest: Bool!
    let nearUserView = RequestView()
    
    var peopleData: GetNearPeopleData!
    
    var datasource: UICollectionViewDiffableDataSource<Int, UserInfoModel>!
    var cellDatasource: UICollectionViewDiffableDataSource<Int, String>!
    
    var popupVC = RequestPopupViewController()
    var timer: Timer!
    override func loadView() {
        view = nearUserView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupVC.delegate = self
        nearUserView.collectionView.delegate = self
        checkMyState()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stateCheck), userInfo: nil, repeats: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
   
    func setDatasource(personData: [FromQueueDB]) {
        let cellReg = UICollectionView.CellRegistration<NearUserCell, UserInfoModel> { [weak self] cell, indexPath, itemIdentifier in
            guard let vc = self else { return }
            let buttonImage = vc.isRequest ? UIImage(named: "Property 1=accept") : UIImage(named: "Property 1=propose")
            
            cell.label.text = itemIdentifier.nick
            cell.image.image = UIImage(named: "sesac_background_\(itemIdentifier.background + 1)")
            cell.characterImage.image = UIImage(named: "sesac_face_\(itemIdentifier.sesac + 1)")
            cell.button.setImage(buttonImage, for: .normal)
            
            guard !personData.isEmpty else { return }
            
            let personData = personData[indexPath.item]
            
            cell.mannerButton.setTitleColor(personData.reputation[0] > 0 ? .white : .black, for: .normal)
            cell.timeButton.setTitleColor(personData.reputation[1] > 0 ? .white : .black, for: .normal)
            cell.responseButton.setTitleColor(personData.reputation[2] > 0 ? .white : .black, for: .normal)
            cell.personalityButton.setTitleColor(personData.reputation[3] > 0 ? .white : .black, for: .normal)
            cell.skillButton.setTitleColor(personData.reputation[4] > 0 ? .white : .black, for: .normal)
            cell.haveAGoodTimeButton.setTitleColor(personData.reputation[5] > 0 ? .white : .black, for: .normal)
            
            cell.mannerButton.backgroundColor = personData.reputation[0] > 0 ? .brandGreen : .white
            cell.timeButton.backgroundColor = personData.reputation[1] > 0 ? .brandGreen : .white
            cell.responseButton.backgroundColor = personData.reputation[2] > 0 ? .brandGreen : .white
            cell.personalityButton.backgroundColor = personData.reputation[3] > 0 ? .brandGreen : .white
            cell.skillButton.backgroundColor = personData.reputation[4] > 0 ? .brandGreen : .white
            cell.haveAGoodTimeButton.backgroundColor = personData.reputation[5] > 0 ? .brandGreen : .white
            
            cell.sesacTextField.text = personData.reviews.first ?? ""
            
            cell.button.tag = indexPath.item
            cell.button.addTarget(vc, action: #selector(vc.insideImageButtonTapped), for: .touchUpInside)
          
        }
        
        datasource = UICollectionViewDiffableDataSource(collectionView: nearUserView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellReg, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, UserInfoModel>()
        snapshot.appendSections([0])
        for item in personData {
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
        let cellReg = UICollectionView.CellRegistration<WriteStudyCell, String> { cell, indexPath, itemIdentifier in
        }
        cellDatasource = UICollectionViewDiffableDataSource(collectionView: cell.collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellReg, for: indexPath, item: itemIdentifier)
            cell.button.setAttributedTitle(self?.makeAttributeTitle(title: itemIdentifier), for: .normal)
            cell.button.layer.borderColor = UIColor.gray2.cgColor
            cell.button.layer.borderWidth = 1
            cell.button.tintColor = .black
            
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        
        snapshot.appendItems(peopleData.fromQueueDB[item].studylist, toSection: 0)
        cellDatasource.apply(snapshot)
        
    }
    
 
    
    func makeAttributeTitle(title: String) -> NSAttributedString {
        let attr = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 14)!])
        return attr
    }
    
    func checkDataisEmpty(bool: Bool) {
        nearUserView.collectionView.isHidden = bool
        nearUserView.imageView.isHidden = !bool
        nearUserView.bottomStackView.isHidden = !bool
    }
    
    @objc func insideImageButtonTapped(_ sender: UIButton) {
        popupVC.popUpView.title.text = "스터디를 요청할게요!"
        popupVC.popUpView.subTitle.text = "상대방이 요청을 수락하면\n채팅창에서 대화를 나눌 수 있어요"
        popupVC.fromQueueDB = peopleData.fromQueueDB[sender.tag]
        present(popupVC, animated: true)
    }
    
    @objc func stateCheck() {
        checkMyState()
    }

    func checkMyState() {
        
        QueueAPIManager.shared.myQueueState { [weak self] response in
//            print("request")
            switch response {
            case .success(let data):
                if data.matched == MyQueueStatus.matched.rawValue {
                    Toast.makeToast(view: self?.view, message: "\(data.matchedNick)님과 매칭되셨습니다.")
                }
            case .failure(let status):
                switch status {
                case .unauthorized: TokenManager.shared.getIdToken { _ in self?.checkMyState()}
                case .notAcceptable: self?.changeSceneToMain(vc: OnBoardingViewController())
                case .internalServerError: Toast.makeToast(view: self?.view, message: "500 Server Error")
                case .notImplemented: Toast.makeToast(view: self?.view, message: "501 Client Error")
                default: Toast.makeToast(view: self?.view, message: status.localizedDescription)
                }
            }
        }
    }
   
    
    
}

extension BaseRequestAndAccpetViewController: UICollectionViewDelegate, SendOpacityProtocol {
    func sendOpacityAndColor(opacity: CGFloat) {
        nearUserView.alpha = opacity
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NearUserCell else { return }
        setInsideCellCollectionViewDatasource(cell: cell, item: indexPath.item)
        
        if cell.stackView5.isHidden {
            
            cell.stackView5.isHidden = false
            
            cell.stackView5.snp.remakeConstraints { make in
                make.top.equalTo(cell.clearView.snp.bottom)
                make.horizontalEdges.equalToSuperview().inset(32)
                make.bottom.equalToSuperview().inset(16)
            }
            
        } else {
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
            cell.foldButton.transform = cell.stackView5.isHidden ? .identity : upsideDown
        }
        datasource.refresh()
    }
    
    
}

