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
        mapView.button.isUserInteractionEnabled = true
    }
    
    @objc func buttonTapped() {
        
        let writeStudyVC = WriteStudyViewController()
        
        guard let pinLocation else { return }
        
        mapViewRefresh(center: pinLocation) { [weak self] data, status in
            guard let data = data else {
                Toast.makeToast(view: self?.view, message: "데이터가 비어있어요")
                return
            }
            writeStudyVC.peopleData = data
            writeStudyVC.long = pinLocation.longitude
            writeStudyVC.lat = pinLocation.latitude
            self?.mapView.button.isUserInteractionEnabled = false
            Toast.makeToast(view: self?.view, message: "데이터를 받아오는중이에요")
            self?.navigationController?.pushViewController(writeStudyVC, animated: true)
        }
    }
    
    
    
    // MARK: - Methods
    
    func mapViewSetUp(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.map.setRegion(region, animated: false)
    }
    
    func mapViewRefresh(center: CLLocationCoordinate2D, completion: @escaping (GetNearPeopleData?, Int?) -> Void) {
        TokenManager.shared.getIdToken { id in
            QueueAPIManager.shared.searchNearPeople(idtoken: id, lat: center.latitude, long: center.longitude) { [weak self] data ,statusCode  in

                guard let vc = self, let data = data else { return }
                vc.mapView.map.removeAnnotations(vc.mapView.map.annotations)
                for i in data.fromQueueDB.indices {
                    let location = CLLocationCoordinate2D(latitude: data.fromQueueDB[i].lat, longitude: data.fromQueueDB[i].long)
                    vc.addCustomPin(sesac_image: data.fromQueueDB[i].sesac + 1, coordinate: location)
                }
                completion(data, statusCode)
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
        mapViewRefresh(center: mapView.centerCoordinate) { [weak self] data, status in
            guard let status else { return }
            if status != 200 {
                Toast.makeToast(view: self?.view, message: "네크워크가 불안정합니다")
            }
        }
        pinLocation = mapView.centerCoordinate
        locationManager.stopUpdatingLocation()
    }
}

extension MainViewController {
    // 현재 위치
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("123123: didUpdateLocations")
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
