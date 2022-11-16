//
//  MainView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/16.
//

import UIKit

import MapKit
import SnapKit

class MainView: BaseView {
    
    let map: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    let annotationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "map_marker")
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func setupUI() {
        self.addSubview(map)
        self.addSubview(annotationImage)
    }
    override func makeConstraints() {
        map.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        annotationImage.snp.makeConstraints { make in
            make.centerX.equalTo(map.snp.centerX)
            make.centerY.equalTo(map.snp.centerY)
        }
        
    }
    
    
}
