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

class MainViewController: BaseViewController, CLLocationManagerDelegate {
    var mapView = MainView()
    
    var locationManager = CLLocationManager()
    var authStatus: CLAuthorizationStatus!
    
    var pinLocation: CLLocationCoordinate2D?
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.map.delegate = self
        locationManager.delegate = self
        
        checkDeviceLocationAuth()
        mapView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        mapView.map.showsUserLocation = true
        mapView.map.setUserTrackingMode(.follow, animated: true)
        mapView.map.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func buttonTapped() {
        
        let writeStudyVC = WriteStudyViewController()
        
        guard let pinLocation else { return }
        
        mapViewRefresh(center: pinLocation) { [weak self] response in
            switch response {
            case .success(let data):
                writeStudyVC.peopleData = data
                writeStudyVC.long = pinLocation.longitude
                writeStudyVC.lat = pinLocation.latitude
                self?.mapView.button.isUserInteractionEnabled = false
                Toast.makeToast(view: self?.view, message: "데이터를 받아오는중이에요")
                self?.navigationController?.pushViewController(writeStudyVC, animated: true)
            case .failure(let status):
                switch status {
                case .unauthorized: TokenManager.shared.getIdToken { _ in self?.buttonTapped() }
                    
                case .notAcceptable: self?.changeSceneToMain(vc: OnBoardingViewController())
                case .internalServerError: Toast.makeToast(view: self?.view, message: "500 Server Error")
                case .notImplemented: Toast.makeToast(view: self?.view, message: "501 Client Error")
                default: Toast.makeToast(view: self?.view, message: "다시 시도 해보세요")
                }
            }
            self?.mapView.button.isUserInteractionEnabled = true
        }
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
                dump(data.fromQueueDB)
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
    
    func checkDeviceLocationAuth() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                if #available(iOS 14.0, *) {
                    self.authStatus = self.locationManager.authorizationStatus
                } else {
                    self.authStatus = CLLocationManager.authorizationStatus()
                }
                self.checkAppLocationAuth(authStatus: self.authStatus)
            } else {
                self.showAlert(title: "기기 위치권한 설정이 되어있지 않습니다.", message: "설정 -> 개인정보 보호 및 보안 -> 위치서비스로 가셔서 권한을 허용해 주세요.")
            }
        }
    }

    func checkAppLocationAuth(authStatus: CLAuthorizationStatus) {
        switch authStatus {
        case .notDetermined:
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        case .restricted, .denied:
            // 아이폰 설정으로 유도
            print("denied")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default: print("DEFAULT")
        }
    }
    
  
    
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapViewRefresh(center: mapView.centerCoordinate) { [weak self] response in
            switch response {
            case .success(_):
                print("break")
                break
            case .failure(let status):
                switch status {
                case .unauthorized:
                    TokenManager.shared.getIdToken { [weak self] id in
                        UserDefaults.standard.set(id, forKey: UserDefaultsKey.idtoken.rawValue)
                        self?.mapView(mapView, regionDidChangeAnimated: animated)
                    }
                case .notAcceptable: self?.changeSceneToMain(vc: OnBoardingViewController())
                case .internalServerError: Toast.makeToast(view: self?.view, message: "500 Server Error")
                case .notImplemented: Toast.makeToast(view: self?.view, message: "501 Client Error")
                default: Toast.makeToast(view: self?.view, message: status.localizedDescription)
                }
            }
        }
        pinLocation = mapView.centerCoordinate
        locationManager.stopUpdatingLocation()
    }
}

extension MainViewController {
    // 현재 위치
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            mapViewSetUp(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuth()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.mapView.map.reloadInputViews()
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
