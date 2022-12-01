//
//  Toast.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/11.
//

import UIKit
import Toast

struct Toast {
    // 리뷰 : - 접근제어 private init
    private init() {}
    static func makeToast(view: UIView?, message: String, duration: Double = 0.7) {
        guard let view = view else { return }
        view.makeToast(message, duration: duration, position: .top)
    }
}
