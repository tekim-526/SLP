//
//  BirthView.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/09.
//

import UIKit
import SnapKit

class BirthView: BaseView {
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "생년월일을 알려주세요"
        label.font = UIFont(name: "NotoSansKR-Regular", size: 20)!
        return label
    }()

    let button: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        button.backgroundColor = .gray6
        button.tintColor = .gray3
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    let yearTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "1990"
        tf.tintColor = .gray7
        tf.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        tf.keyboardType = .numberPad
        tf.tintColor = .clear
        tf.textAlignment = .center
        tf.isEnabled = false
        return tf
    }()
        
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "년"
        return label
    }()
    
    lazy var yearView: UIView = {
        let view = UIView().yearMonthDayView(textField: yearTextField, label: yearLabel)
        return view
    }()
    
    let monthTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "1"
        tf.tintColor = .gray7
        tf.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        tf.keyboardType = .numberPad
        tf.textAlignment = .center
        tf.tintColor = .clear
        tf.isEnabled = false
        return tf
    }()
        
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "월"
        return label
    }()
    
    lazy var monthView: UIView = {
        let view = UIView().yearMonthDayView(textField: monthTextField, label: monthLabel)
        return view
    }()
    
    let dayTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "1"
        tf.tintColor = .gray7
        tf.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        tf.keyboardType = .numberPad
        tf.textAlignment = .center
        tf.tintColor = .clear
        tf.isEnabled = false
        return tf
    }()
        
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        return label
    }()
    
    lazy var dayView: UIView = {
        let view = UIView().yearMonthDayView(textField: dayTextField, label: dayLabel)
        return view
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(yearView)
        stackView.addArrangedSubview(monthView)
        stackView.addArrangedSubview(dayView)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        [label, stackView, button].forEach { self.addSubview($0) }
    }
    override func makeConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(97)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(80)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(48)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(72)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(48)
        }
        
    }
}
