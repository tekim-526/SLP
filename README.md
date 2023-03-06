## ‘스터디 매칭 프로젝트’ - 2022.11.07 ~ 2022.12.07

☘️새싹들을 위한 스터디 매칭하고 1:1채팅을 하는 서비스
 
<img src="https://user-images.githubusercontent.com/81205931/222653020-dcd84527-c90f-490f-b4d7-2ff79beeb621.png">


## 📱 **기능 요약** 
- SocektIO를 이용한 스터디 매칭 및 매칭된 사람과의 채팅 기능
- RxSwift, RxCocoa를 이용한 회원가입 로직 및 기능
- jwt token기반 회원인증로직 구현 (회원가입 / 로그인 / 회원탈퇴)
- 매칭을 요청 및 수락 및 중단기능
- 가입할때 입력한 내 정보 확인 및 수정
- 상대방 정보 확인 기능
- MapKit의 Annotation 통한 지도를 통한 주변 사람 시각화
- 서치바와 Modern Collection View Layout을 통한 스터디 입력 기능

## **UI**
- ### ```CodeBaseUI```
## **Architecture**
- ### ```MVC```, ```MVVM``` 
##  **Framework & Library**
- ### ```UIKit```, ```MapKit```, ```CoreLocation```
- ### ```RxSwift```, ```RxCocoa```, ```Alamofire```, ```SocketIO```,  ```Realm```, ```Firebase Auth```, ```SnapKit```, ```Toast```, ```MultiSlider``` 

## **Trouble Shooting**
### Firebase Auth를 활용한 SMS인증 
- Firebase 공식 문서를 통해 해결
``` swift
class AuthManager {
    static let shared = AuthManager()
    
    private init() {}

    private let auth = Auth.auth()

    private var verificationId: String?
    
    func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else { return }
            self?.verificationId = verificationId
            completion(true)
        }
    }
    
    func verifySMS(sms: String, completion: @escaping (Bool) -> Void) {
        guard let verificationId = verificationId else {
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: sms)
        auth.languageCode = "kr"
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}
```
### **정규식을 사용한 휴대폰번호 유효성 검사**
- 정규식의 존재를 몰랐기 때문에 String의 extension을 만들어서 유효성 검사하려 했으나, 30분만에 정규식의 존재를 알게되고 만든 휴대폰 번호 유효성 검사 함수
``` swift
func phoneValid(number: String) -> Bool {
    let pattern = "^01([0-9])-?([0-9]{3,4})-?([0-9]{4})$"
    let regex = try? NSRegularExpression(pattern: pattern)
    if let _ = regex?.firstMatch(in: number, options: [], range: NSRange(location: 0, length: number.count)) {
        return true
    } else {
        return false
    }
}
```
### **열거형의 원시값을 활용한 네트워크 통신 분기처리**
- 기존 url에서 path가 중복이 되고 baseurl이 같다면 중복되는 내용의 코드를 줄일 수 있을것 같다고 생각했고, 열거형의 원시값을 통해 해결했다.

``` swift
@frozen
enum MyStudy: String {
    case studyrequest
    case studyaccept
    case dodge
}

func myStudy(idtoken: String = UserDefaults.standard.string(forKey: UserDefaultsKey.idtoken.rawValue) ?? "", method: MyStudy = .studyrequest, otheruid: String, completion: @escaping (NetworkStatus) -> Void) {
    let url = BaseURL.baseURL + "v1/queue/\(method.rawValue)"
    let headers: HTTPHeaders = ["idtoken": idtoken]   
    let parameters = RequestStudy(otheruid: otheruid)
                
    AF.request(url, method: .post, parameters: parameters, headers: headers).validate().response { response in
        guard let statusCode = response.response?.statusCode else { return }
        guard let status = NetworkStatus(rawValue: statusCode) else { return }
        completion(status)
    }
}

// 추가 - 열거형을 통한 네트워크 Status Code처리
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
```
### **Timer를 활용해서 5초마다 상태체크 메서드 실행**
- 처음에는 DispatchQueue에 시간관련한 메서드들을 사용하려했지만 5초마다 상태를 체크해야하기 때문에 스케쥴링과 관련해서 반복적으로 수행될 객체 메서드등이 필요했고 Timer로 해결. 
```swift
timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stateCheck), userInfo: nil, repeats: true)
```
### **Expandable Cell 구현**
- 이부분 때문에 tableView로 구현을 하면 더 쉬울까 생각을 했지만 deprecate될 예정이라고 알고있어서 사용하고 싶지 않았고 Autolayout 관련해서 여러가지 시행착오들을 겪었다. 
``` swift
// 첫번째 방법 setCollectionViewLayout(_:animated:completion:)메서드 활용해서 UICollectionView의 레이아웃을 새로 지정해주는 방식
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
	isExpanded.toggle()
}

// 두번째 방법 cell의 레이아웃을 remake하는 방식
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
}
``` 


### 📝 **회고**

Confluence, Swagger, Figma를 통한 개발 명세가 세세하고 위의 툴들을 처음 사용해봐서 어색함이 많았지만 사용하면 할수록 재밌었고 많은걸 배워갔던 것같다.

소켓통신과 Modern CollectionView Layout을 프로젝트에 적용시켜본게 처음이었는데 시행착오도 많았지만 결과적으로 원하는 방향으로 동작하게 되어서 만족스러웠던 프로젝트였다


### ___아쉬웠던 점___
코드를 작성함에 있어 MVVM패턴과 Rx를 제한적으로 적용했던 점이 아쉬웠고 두 부분에 대해서 공부가 충분하지 않았고 많이 부족함을 느꼈던 것 같다. 또한, 상단의 코드에서도 나오는 부분인데 literal값을 바로 사용했던 것 같이 리팩토링을 고려하지 않은 부분이 많았던 것 같다. 이러한 부분을 열거형의 원시값으로 처리했다면 어땠을까 하는 생각이 든다. literal값을 줄이는 수정을 빠른시일내에 해야겠다는 생각이 든다. 또한 반복되는 코드들이 많은데 제네릭과 enum의 케이스를 더 적극적으로 사용했다면 조금 더 효율적으로 코드를 작성해볼수 있었을것같아서 아쉬움이 남는다.
