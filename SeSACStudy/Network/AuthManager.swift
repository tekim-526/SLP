//
//  AuthManager.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/10.
//

import Foundation
import FirebaseAuth

// 리뷰 : - 싱글톤 패턴으로만 구성하는게 적합할까? 싱글톤 패턴의 목적에 대해서 생각해보자

class AuthManager {
    static let shared = AuthManager()
    
    private init() {}

    private let auth = Auth.auth()

    private var verificationId: String?
    
    func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else { return }
            self?.verificationId = verificationId
            completion(true)
        }
    }
    
    func verifySMS(sms: String, completion: @escaping (Bool) -> Void) {
        guard let verificationId = verificationId else {
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: sms)
        auth.languageCode = "kr"
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}
