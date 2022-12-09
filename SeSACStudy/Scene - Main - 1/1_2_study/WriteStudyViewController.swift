//
//  WriteStudyView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/17.
//

import UIKit

class WriteStudyViewController: BaseViewController {
    let writeView = WriteStudyView()
    let keyboardHeaderView = KeyboardHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 48))
    
    var datasource: UICollectionViewDiffableDataSource<Int, StudyModel>!
    var snapshot = NSDiffableDataSourceSnapshot<Int, StudyModel>()
    
    var peopleData: GetNearPeopleData!
    
    var long: Double!
    var lat: Double!
    var list: [StudyModel] = []
    
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeView.collectionView.delegate = self
        
        setDataSource()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        writeView.button.isUserInteractionEnabled = true
        keyboardHeaderView.button.isUserInteractionEnabled = true
    }
   
    override func setupUI() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 28, height: 0))
        searchBar.inputAccessoryView = keyboardHeaderView
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.delegate = self
        keyboardHeaderView.button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        writeView.button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    
        makeNavigationUI(rightBarButtonItem: UIBarButtonItem(customView: searchBar))
        navigationController?.navigationBar.isHidden = false
        
    }
    private func setDataSource() {
        let cellRegisteration = UICollectionView.CellRegistration<WriteStudyCell, StudyModel> {  cell, indexPath, itemIdentifier in
            
        }
        datasource = UICollectionViewDiffableDataSource(collectionView: writeView.collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            if indexPath.section == 0 {
                switch itemIdentifier.isRecommand {
                case true:
                    cell.button.tintColor = .systemError
                    cell.button.layer.borderColor = UIColor.systemError.cgColor
                case false:
                    cell.button.tintColor = .black
                    cell.button.layer.borderColor = UIColor.gray2.cgColor
                }
                cell.button.setAttributedTitle(self?.makeAttributeTitle(title: itemIdentifier.studyName), for: .normal)
            } else if indexPath.section == 1 {
                cell.button.setAttributedTitle(self?.makeAttributeTitle(title: itemIdentifier.studyName + " "), for: .normal)
                cell.button.layer.borderColor = UIColor.brandGreen.cgColor
                cell.button.setImage(UIImage(systemName: "xmark"), for: .normal)
                cell.button.tintColor = .brandGreen
            }
            cell.button.layer.borderWidth = 1
            return cell
        }
        
        let header = UICollectionView.SupplementaryRegistration<WriteStudyHeader>(elementKind: "header") { supplementaryView, elementKind, indexPath in
            switch indexPath.section {
            case 0:
                supplementaryView.label.text = "지금 주변에는"
            default:
                supplementaryView.label.text = "내가 하고 싶은"
            }
        }
        
        datasource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            let header = collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
            return header
        })
        
        snapshot.appendSections([0, 1])
        snapshot.appendItems(setStudyModel(data: peopleData)[0], toSection: 0)
        snapshot.appendItems(setStudyModel(data: peopleData)[1], toSection: 0)
        datasource.apply(snapshot)
        
    }
    
    func makeAttributeTitle(title: String) -> NSAttributedString {
        let attr = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont(name: "NotoSansKR-Regular", size: 14)!])
        return attr
    }
    
    func setStudyModel(data: GetNearPeopleData) -> [[StudyModel]] {
        var recommands: [StudyModel] = []
        var studyLists: [StudyModel] = []
        
        for recommand in data.fromRecommend {
            recommands.append(StudyModel(recommand, isRecommand: true))
        }
        
        for person in data.fromQueueDB {
            for studyName in person.studylist {
                if studyLists.count > 7 {
                    break
                }
                studyLists.append(StudyModel(studyName))
            }
        }
        return [recommands, studyLists]
    }
    
    @objc func searchButtonTapped(sender: UIButton) {
        // Post Method Needed
        sender.isUserInteractionEnabled = false
        var studylist: [String] = []
        for item in datasource.snapshot(for: 1).items {
            studylist.append(item.studyName)
        }
        
        guard !studylist.isEmpty else {
            Toast.makeToast(view: view, message: "내가 하고 싶은 스터디를 입력해주세요")
            return
        }
        TokenManager.shared.getIdToken { token in
            QueueAPIManager.shared.searchNearPeopleWithMyStudy(lat: self.lat, long: self.long, studylist: studylist) { [weak self] statuscode in
                guard let vc = self else { return }
                switch statuscode {
                case .ok:
                    let nearRequestVC = RequestAndAcceptViewController()
                    nearRequestVC.peopleData = vc.peopleData
                    nearRequestVC.pinLocation = (vc.lat, vc.long)
                    self?.navigationController?.pushViewController(nearRequestVC, animated: true)
                case .created: Toast.makeToast(view: vc.view, message: "신고가 누적되어 이용하실 수 없습니다")
                case .nonAuthoritativeInformation: Toast.makeToast(view: vc.view, message: "스터디 취소 패널티로, 1분동안 이용하실 수 없습니다")
                case .noContent: Toast.makeToast(view: vc.view, message: "스터디 취소 패널티로, 2분동안 이용하실 수 없습니다")
                case .resetContent: Toast.makeToast(view: vc.view, message: "스터디 취소 패널티로, 3분동안 이용하실 수 없습니다")
                case .unauthorized: TokenManager.shared.getIdToken { _ in Toast.makeToast(view: vc.view, message: "다시 시도 해주세요")}
                case .notAcceptable: vc.changeSceneToMain(vc: OnBoardingViewController())
                case .internalServerError: Toast.makeToast(view: vc.view, message: "500 Server Error")
                case .notImplemented: Toast.makeToast(view: vc.view, message: "501 Client Error")
                default: Toast.makeToast(view: vc.view, message: "다시 시도 해보세요")
                }
            }
        }
        
    }
}

extension WriteStudyViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
       
        let tempArray = text.split(separator: " ").map { String($0) }
        let ret = Array(Set(tempArray).sorted())
        
        var nameSet = Set<String>()
        for i in snapshot.itemIdentifiers(inSection: 1) {
            nameSet.insert(i.studyName)
        }
        for str in ret {
            if !nameSet.contains(str) {
                if snapshot.itemIdentifiers(inSection: 1).count > 7 {
                    Toast.makeToast(view: view, message: "스터디를 더이상 추가할 수 없습니다")
                } else {
                    if str.count > 8 {
                        Toast.makeToast(view: view, message: "최대 8글자까지 작성 가능합니다")
                    } else {
                        snapshot.appendItems([StudyModel(str)], toSection: 1)
                    }
                }
            } else {
                Toast.makeToast(view: view, message: "이미 추가된 스터디입니다")
            }
            
        }
        datasource.apply(snapshot)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension WriteStudyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? WriteStudyCell else {return}
        guard let text = cell.button.titleLabel?.text else { return }
        
        var nameSet = Set<String>()
        for i in snapshot.itemIdentifiers(inSection: 1) {
            nameSet.insert(i.studyName)
        }
        
        if indexPath.section == 0 {
            if snapshot.itemIdentifiers(inSection: 1).count >= 8 {
                Toast.makeToast(view: view, message: "스터디를 더이상 추가할 수 없습니다")
                return
            }
            if nameSet.contains(text) {
                Toast.makeToast(view: view, message: "이미 등록된 스터디입니다")
            } else {
                let temp = StudyModel(text)
                snapshot.appendItems([temp], toSection: 1)
                datasource.apply(snapshot)
            }
        } else if indexPath.section == 1 {
            let willRemove = snapshot.itemIdentifiers(inSection: 1)[indexPath.item]
            snapshot.deleteItems([willRemove])
            datasource.apply(snapshot)
        }
    }
}
