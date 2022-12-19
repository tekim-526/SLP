## ‘SLP’ - 2022.11.07 ~

☘️새싹들을 위한 스터디 매칭 어플리케이션

### 📱 **담당한 부분** 
- 스터디 매칭된 사람과의 채팅 기능
- 매칭을 위한 요청 및 수락 기능
- 매칭 중단 기능
- 가입할때 입력한 내 정보 확인 및 수정
- 상대방 정보 확인 기능
- 지도를 통한 주변 사람 찾기 기능
- 서치바를 통한 스터디 입력 기능
- 회원탈퇴 기능

### 📌 **사용한 기술**
- UIKit
- MapKit
- CoreLocation
- RxSwift
- RxCocoa
- Alamofire
- Firebase
- SocketIO
- Realm
- SnapKit
- Toast
- MultiSlider

### 📝 **회고**

Confluence, Swagger, Figma를 통한 개발 명세가 세세하고 위의 툴들을 처음 사용해봐서 어색함이 많았지만 사용하면 할수록 재밌었고 많은걸 배워갔던 것 같다.

소켓통신과 Modern CollectionView Layout을 프로젝트에 적용시켜본게 처음이었는데 시행착오도 많았지만 결과적으로 원하는 방향으로 동작하게 되어서 만족스러웠던 프로젝트 였다

### ___어려웠던 점___

첫번째로 소켓통신을 사용할때 하단의 코드에서 .forceWebsockets(true) 부분 때문에 애먹었었는데 알아본 바로는 config에 .forceWebsockets(true)를 주는 이유는 서버 로직에 따라서도 다를 수 있는데, 클라이언트는 일반적으로 웹소켓 기반으로 통신하기 때문에 다른 통신이 아닌 웹소켓으로 통신하게끔 처리해야하기 때문에 처리를 해줘야 한다고한다.
``` swift
class SocketIOManager {
	// 중략
    var manager: SocketManager!
	// 중략
    manager = SocketManager(socketURL: URL(string: BaseURL)!, config: compress, .forceWebsockets(true)])
	// 중략
}
``` 

두번째로 UICollectionView의 Cell을 Expandable Cell로 만드는 부분이었는데 다이나믹한 뷰를 그릴때 layout을 확실하게 지정해야겠다고 깨닳은 부분이었다. 

해결방법은 두가지였는데 첫번째 방법은 컬렉션뷰를 탭할때 레이아웃을 새롭게 지정해주는 방식이었고, 두번째 방법은 Cell내부에 있는 뷰 객체들을 UIStackView로 묶어서 높이를 리터럴 값으로 지정해주는 방식이었다.

두가지 해결책을 다른곳에 사용해 보면서 나에게 더 맞은 방식이라고 생각했던 부분은 애니메이션 효과와 같이 결과물을 보았을 때 뷰가 더 부드럽게 움직인다는 느낌을 받았던 부분은 첫번째방법이었다. 또한 첫번째 방식은 BaseView가 되는 클래스에서 사용한 createLayout 메서드를 재사용할 수 있다는 점에서 더 좋은 방식이라고 생각이 들었다.
``` swift
// 첫번째 방법 ↓ UICollectionView의 레이아웃을 새로 지정해주는 방식
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

// 두번째 방법 ↓ cell의 레이아웃을 수정하는 방식
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

### ___아쉬웠던 점___
코드를 작성함에 있어 MVVM패턴과 Rx를 제한적으로 적용했던 점이 아쉬웠고 두 부분에 대해서 공부가 충분하지 않았고 많이 부족함을 느꼈던 것 같다. 또한, 상단의 코드에서도 나오는 부분인데 literal값을 바로 사용했던 것 같이 리팩토링을 고려하지 않은 부분이 많았던 것 같다. 이러한 부분을 열거형의 원시값으로 처리했다면 어땠을까 하는 생각이 든다. literal값을 줄이는 수정을 빠른시일내에 해야겠다는 생각이 든다.
