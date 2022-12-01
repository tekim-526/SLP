//
//  LocationManager.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/30.
//

import Foundation

import CoreLocation

final class LocationManager {
    var locationManager = CLLocationManager()
    var authStatus: CLAuthorizationStatus!
    
    func checkDeviceLocationAuth(completion: @escaping () ->()) {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                if #available(iOS 14.0, *) {
                    self.authStatus = self.locationManager.authorizationStatus
                } else {
                    self.authStatus = CLLocationManager.authorizationStatus()
                }
                self.checkAppLocationAuth(authStatus: self.authStatus)
            } else {
                completion()
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
