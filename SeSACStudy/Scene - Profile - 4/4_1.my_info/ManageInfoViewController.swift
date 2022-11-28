//
//  ManageInfoViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/14.
//

import UIKit
import SnapKit
import MultiSlider

import RxCocoa
import RxSwift

class ManageInfoViewController: BaseViewController {
    let manageInfoView = ManageInfoView()
    let popupVC = PopupViewController()
    let disposeBag = DisposeBag()
    
    var datasource: UICollectionViewDiffableDataSource<Int, String>!
    var isExpanded: Bool = false
    var alpha: CGFloat = 0.5
    var data: MyInFoData!
    override func loadView() {
        view = manageInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatasource(reputation: data.reputation, gender: data.gender, searchable: data.searchable, study: data.study, ageMin: CGFloat(data.ageMin), ageMax: CGFloat(data.ageMax))
        
        popupVC.delegate = self
        manageInfoView.collectionView.delegate = self
    }
    
    override func setupUI() {
        let rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveBarButtonTapped))
        makeNavigationUI(title: "정보 관리", rightBarButtonItem: rightBarButtonItem)
    }
    
    func setDatasource(reputation: [Int] = [0, 0, 0, 0, 0, 0],
                       gender: Int = 2,
                       searchable: Int = 1,
                       study: String = "",
                       ageMin: CGFloat = 18,
                       ageMax: CGFloat = 37) {
        let expandableCellRegisteration = UICollectionView.CellRegistration<ExpandableCell, String> { cell, indexPath, item in
            cell.label.text = item
            for i in cell.buttons.indices {
                if reputation[i] > 0 {
                    cell.buttons[i].backgroundColor = .brandGreen
                    cell.buttons[i].setTitleColor(.white, for: .normal)
                }
            }
        }
        let genderCellRegisteration = UICollectionView.CellRegistration<GenderCell, String> { cell, indexPath, item in
            cell.label.text = item
            cell.maleButton.setTitleColor(gender == 1 ? .white : .black, for: .normal)
            cell.maleButton.backgroundColor = gender == 1 ? .brandGreen : .white
            cell.femaleButton.setTitleColor(gender == 0 ? .white : .black, for: .normal)
            cell.femaleButton.backgroundColor = gender == 0 ? .brandGreen : .white
        }
        let studyCellRegisteration = UICollectionView.CellRegistration<StudyCell, String> { cell, indexPath, item in
            cell.label.text = item
            cell.textField.text = study
        }
        let phoneNumberPermitCellRegisteration = UICollectionView.CellRegistration<PhoneNumberPermitCell, String> { cell, indexPath, item in
            cell.label.text = item
            cell.mySwitch.isOn = searchable == 1 ? true : false
        }
        let ageCellRegisteration = UICollectionView.CellRegistration<AgeCell, String> { cell, indexPath, item in
            cell.label.text = item
            cell.rangeLabel.text = "\(Int(ageMin))-\(Int(ageMax))"
            cell.slider.value = [ageMin, ageMax]
        }
        datasource = UICollectionViewDiffableDataSource(collectionView: manageInfoView.collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: expandableCellRegisteration, for: indexPath, item: itemIdentifier)
                return cell
            } else if indexPath.section == 1 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: genderCellRegisteration, for: indexPath, item: itemIdentifier)
                cell.maleButton.rx.tap
                    .bind { _ in
                        self?.data.gender = 1
                    }.disposed(by: self?.disposeBag ?? DisposeBag())
                
                cell.femaleButton.rx.tap
                    .bind { _ in
                        self?.data.gender = 0
                    }.disposed(by: self?.disposeBag ?? DisposeBag())
                return cell
            } else if indexPath.section == 2 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: studyCellRegisteration, for: indexPath, item: itemIdentifier)
                cell.textField.rx.text
                    .bind { value in
                        self?.data.study = value ?? ""
                    }.disposed(by: self?.disposeBag ?? DisposeBag())
                return cell
            } else if indexPath.section == 3 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: phoneNumberPermitCellRegisteration, for: indexPath, item: itemIdentifier)
                cell.mySwitch.rx.isOn
                    .bind { bool in
                        self?.data.searchable = bool ? 1 : 0
                    }.disposed(by: self?.disposeBag ?? DisposeBag())
                return cell
            } else if indexPath.section == 4{
                let cell = collectionView.dequeueConfiguredReusableCell(using: ageCellRegisteration, for: indexPath, item: itemIdentifier)
                cell.slider.rx.controlEvent(.touchUpInside)
                    .subscribe { value in
                        self?.data.ageMax = Int(cell.slider.value[1])
                        self?.data.ageMin = Int(cell.slider.value[0])
                    }.disposed(by: self?.disposeBag ?? DisposeBag())
                return cell
            } else {
                let cell = collectionView.dequeueConfiguredReusableCell(using: genderCellRegisteration, for: indexPath, item: itemIdentifier)
                cell.stackView.isHidden = true
                return cell
            }
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        
        snapshot.appendSections([0, 1, 2, 3, 4, 5])
        snapshot.appendItems([UserDefaults.standard.string(forKey: "nick") ?? "NULL"], toSection: 0)
        snapshot.appendItems(["내 성별"], toSection: 1)
        snapshot.appendItems(["자주하는 스터디"], toSection: 2)
        snapshot.appendItems(["내 번호 검색 허용"], toSection: 3)
        snapshot.appendItems(["상대방 연령대"], toSection: 4)
        snapshot.appendItems(["회원탈퇴"], toSection: 5)
        datasource.apply(snapshot)
    }
    @objc func saveBarButtonTapped() {
        guard let id = UserDefaults.standard.string(forKey: UserDefaultsKey.idtoken.rawValue) else { return }
        UserAPIManager.shared.myPage(idtoken: id, searchable: data.searchable, ageMin: data.ageMin, ageMax: data.ageMax, gender: data.gender, study: data.study) { [weak self] status in
            switch status {
            case .ok:
                self?.navigationController?.popViewController(animated: true)
            case .unauthorized:
                TokenManager.shared.getIdToken { id in
                    UserDefaults.standard.set(id, forKey: "idtoken")
                }
                self?.saveBarButtonTapped()
            case .notAcceptable: print() //가입되지 않은 회원입니다
            case .internalServerError: Toast.makeToast(view: self?.view, message: "500 Server Error")
            case .notImplemented: Toast.makeToast(view: self?.view, message: "501 Client Error")
            default:  Toast.makeToast(view: self?.view, message: "\(status.localizedDescription)")
            }
        }
    }
}
extension ManageInfoViewController: UICollectionViewDelegate, SendOpacityProtocol {
    func sendOpacityAndColor(opacity: CGFloat) {
        manageInfoView.alpha = opacity
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == [0, 0] {
            guard let cell = collectionView.cellForItem(at: [0, 0]) as? ExpandableCell else { return }
            switch isExpanded {
            case true:
                collectionView.setCollectionViewLayout(manageInfoView.createLayout(height: 58), animated: true)
                cell.sesacTitleLabel.isHidden = true
                cell.stackView4.isHidden = true
                cell.sesacReviewLabel.isHidden = true
                cell.sesacTextField.isHidden = true
                cell.foldButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                
            case false:
                collectionView.setCollectionViewLayout(manageInfoView.createLayout(height: 310), animated: true) { _ in
                    cell.sesacTitleLabel.isHidden = false
                    cell.stackView4.isHidden = false
                    cell.sesacReviewLabel.isHidden = false
                    cell.sesacTextField.isHidden = false
                }
                cell.foldButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)

            }
            isExpanded.toggle()
        } else if indexPath == [5, 0] {
            popupVC.modalPresentationStyle = .overFullScreen
            
            manageInfoView.alpha = 0.5
            present(popupVC, animated: true)
        }
       
    }
    
}

