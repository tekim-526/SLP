//
//  AgeCell.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/15.
//

import UIKit
import SnapKit
import MultiSlider
class AgeCell: BaseCollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        return label
    }()
    
    let slider: MultiSlider = {
        let slider = MultiSlider()
        slider.orientation = .horizontal
        slider.minimumValue = 18
        slider.maximumValue = 65
        slider.snapStepSize = 1
        slider.outerTrackColor = .gray2
        slider.trackWidth = 4
        slider.isHapticSnap = true
        slider.tintColor = .brandGreen
        slider.thumbCount = 2
        slider.thumbImage = UIImage(named: "filter_control")
        slider.keepsDistanceBetweenThumbs = true
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    let rangeLabel: UILabel = {
        let label = UILabel()
        label.text = "18-65"
        label.font = UIFont(name: "NotoSansKR-Medium", size: 14)
        label.textColor = .brandGreen
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func setupUI() {
        [label, rangeLabel, slider].forEach { self.contentView.addSubview($0) }
    }
    override func makeConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
        }
        rangeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        slider.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
    }
    @objc func sliderValueChanged(sender: MultiSlider) {
        rangeLabel.text = "\(Int(sender.value[0]))-\(Int(sender.value[1]))"
    }
    
}
