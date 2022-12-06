//
//  MainViewController.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/10.
//

import UIKit

import CoreLocation
import MapKit
import SnapKit

// 리뷰 : - 로케이션 관리하는 매니저로 만들어보자 - APIManager 처럼

class MainViewController: BaseViewController, CLLocationManagerDelegate {
    var mapView = MainView()
    
    var pinLocation: CLLocationCoordinate2D?
    
    var locationManager = LocationManager()
    var myQueueState: MyQueueState!
    var matchedNick: String!
    var timer: Timer!
    
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.map.delegate = self
        locationManager.locationManager.delegate = self
        
        locationManager.checkDeviceLocationAuth {
            self.showAlert(title: "기기 위치권한 설정이 되어있지 않습니다.", message: "설정 -> 개인정보 보호 및 보안 -> 위치서비스로 가셔서 권한을 허용해 주세요.")
        }
        
        mapView.button.addTarget(self, action: #selector(stableButtonTapped), for: .touchUpInside)
        mapView.locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
                
        mapView.map.setUserTrackingMode(.follow, animated: true)
        mapView.map.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
    
        mapView.map.showsUserLocation = false
        
        makeNavigationUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        checkMyState()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stateCheck), userInfo: nil, repeats: true)
        mapView.button.isUserInteractionEnabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func stateCheck() {
        checkMyState()
    }
    
    @objc func locationButtonTapped() {
        guard let coordinate = locationManager.locationManager.location?.coordinate else {
            Toast.makeToast(view: view, message: "위치를 불러올 수 없습니다.")
            return
        }
        
        mapViewSetUp(center: coordinate)
    }
    
    @objc func stableButtonTapped() {
        let writeStudyVC = WriteStudyViewController()
        guard let pinLocation else { return }
        
        QueueAPIManager.shared.searchNearPeople(lat: pinLocation.latitude, long: pinLocation.longitude) { [weak self] result  in
            switch result {
            case .success(let data):
                writeStudyVC.peopleData = data
                writeStudyVC.long = pinLocation.longitude
                writeStudyVC.lat = pinLocation.latitude
                self?.mapView.button.isUserInteractionEnabled = false
                Toast.makeToast(view: self?.view, message: "데이터를 받아오는중이에요")
                self?.navigationController?.pushViewController(writeStudyVC, animated: true)
            case .failure(let status):
                switch status {
                case .unauthorized: TokenManager.shared.getIdToken { _ in self?.stableButtonTapped() }
                default:
                    self?.handleError(status: status)
                }
            }
            
        }
    }

    @objc func matchingButtonTapped() {
        let vc = RequestAndAcceptViewController()
        
        guard let pinLocation else { return }
        
        QueueAPIManager.shared.searchNearPeople(lat: pinLocation.latitude, long: pinLocation.longitude) { [weak self] result  in
            switch result {
            case .success(let data):
                vc.peopleData = data
                self?.mapView.button.isUserInteractionEnabled = false
                Toast.makeToast(view: self?.view, message: "데이터를 받아오는중이에요")
                self?.navigationController?.pushViewController(vc, animated: true)
            case .failure(let status):
                switch status {
                case .unauthorized: TokenManager.shared.getIdToken { _ in self?.stableButtonTapped() }
                default:
                    self?.handleError(status: status)
                }
            }
            self?.mapView.button.isUserInteractionEnabled = true
        }
    }
    @objc func matchedButtonTapped() {
        let vc = ChatViewController()
        guard myQueueState != nil else { return }
        vc.myQueueState = myQueueState
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkMyState() {
        QueueAPIManager.shared.myQueueState { [weak self] response in
            switch response {
            case .success(let data):
                self?.setButton(myStatus: MyQueueStatus(rawValue: data.matched) ?? .stable)
                self?.myQueueState = data
                
                switch data.matched {
                case MyQueueStatus.matched.rawValue:
                    switch data.dodged {
                    case MyQueueStatus.matched.rawValue:
                        QueueAPIManager.shared.myStudy(method: .dodge, otheruid: data.matchedUid) { status in }
                    default:
                        Toast.makeToast(view: self?.view, message: "\(data.matchedNick)님과 매칭되셨습니다.")
                    }
                default:
                    break
                }
            case .failure(let status):
                switch status {
                case .created:
                    self?.mapView.button.setImage(UIImage(named: "Property 1=default"), for: .normal)
                    self?.setButton(myStatus: .stable)
                case .unauthorized: TokenManager.shared.getIdToken { _ in self?.checkMyState()}
                default:
                    self?.handleError(status: status)
                }
            }
        }
    }
    
    func setButton(myStatus: MyQueueStatus) {
        let buttonImage = myStatus == .stable ? UIImage(named: "Property 1=default") : myStatus == .matched ? UIImage(named: "Property 1=matched") : UIImage(named: "Property 1=matching")
        mapView.button.removeTarget(nil, action: nil, for: .allEvents)
        switch myStatus {
        case .stable:
            mapView.button.addTarget(self, action: #selector(stableButtonTapped), for: .touchUpInside)
        case .matched:
            mapView.button.addTarget(self, action: #selector(matchedButtonTapped), for: .touchUpInside)
        case .matching:
            mapView.button.addTarget(self, action: #selector(matchingButtonTapped), for: .touchUpInside)
        }
        
        mapView.button.setImage(buttonImage, for: .normal)
    }
    
    // MARK: - Methods
    func mapViewSetUp(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.map.setRegion(region, animated: false)
    }
    
    func mapViewRefresh(center: CLLocationCoordinate2D, completion: @escaping (Result<GetNearPeopleData, NetworkStatus>) -> Void) {
        QueueAPIManager.shared.searchNearPeople(lat: center.latitude, long: center.longitude) { [weak self] result  in
            guard let vc = self else { return }
            switch result {
            case .success(let data):
                vc.mapView.map.removeAnnotations(vc.mapView.map.annotations)
                for i in data.fromQueueDB.indices {
                    let location = CLLocationCoordinate2D(latitude: data.fromQueueDB[i].lat, longitude: data.fromQueueDB[i].long)
                    vc.addCustomPin(sesac_image: data.fromQueueDB[i].sesac + 1, coordinate: location)
                }
                completion(.success(data))
            case .failure(let status):
                completion(.failure(status))
            }
        }
    }

    func addCustomPin(sesac_image: Int, coordinate: CLLocationCoordinate2D) {
       let pin = CustomAnnotation(sesac_image: sesac_image, coordinate: coordinate)
        mapView.map.addAnnotation(pin)
    }
    
    
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapViewRefresh(center: mapView.centerCoordinate) { [weak self] response in
            switch response {
            case .success(_):
                break
            case .failure(let status):
                switch status {
                case .unauthorized:
                    TokenManager.shared.getIdToken { [weak self] id in
                        UserDefaults.standard.set(id, forKey: UserDefaultsKey.idtoken.rawValue)
                        self?.mapView(mapView, regionDidChangeAnimated: animated)
                    }
                default:
                    self?.handleError(status: status)
                }
            }
        }
        pinLocation = mapView.centerCoordinate
        locationManager.locationManager.stopUpdatingLocation()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        let sesacImage: UIImage!
        let size = CGSize(width: 85, height: 85)
        UIGraphicsBeginImageContext(size)

        switch annotation.sesac_image {
        case 0:
            sesacImage = UIImage(named: "sesac_face_1")
        case 1:
            sesacImage = UIImage(named: "sesac_face_2")
        case 2:
            sesacImage = UIImage(named: "sesac_face_3")
        case 3:
            sesacImage = UIImage(named: "sesac_face_4")
        default:
            sesacImage = UIImage(named: "sesac_face_5")
        }
        
        sesacImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        return annotationView
    }
}

extension MainViewController {
    // 현재 위치
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            mapViewSetUp(center: coordinate)
        }
        locationManager.locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.checkDeviceLocationAuth {
            self.showAlert(title: "기기 위치권한 설정이 되어있지 않습니다.", message: "설정 -> 개인정보 보호 및 보안 -> 위치서비스로 가셔서 권한을 허용해 주세요.")
        }
    }
}
