//
//  AuthManager.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/10.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    private init() {}
    private let auth = Auth.auth()
    
    private var verificationId: String?
    func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        auth.languageCode = "kr"
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
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
}