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
    let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Property 1=default"), for: .normal)
        return button
    }()
    
    
    let locationButton: UIButton = {
        return UIButton().makeFloatingButton(image: UIImage(named: "place"))
    }()
    
    
    lazy var bigStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    lazy var smallStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func setupUI() {
        self.addSubview(map)
        self.addSubview(annotationImage)
        self.addSubview(button)
        self.addSubview(locationButton)
    }
    override func makeConstraints() {
        map.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        annotationImage.snp.makeConstraints { make in
            make.centerX.equalTo(map.snp.centerX)
            make.centerY.equalTo(map.snp.centerY)
        }
        
        button.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(48)
        }
    }
    
    
}
