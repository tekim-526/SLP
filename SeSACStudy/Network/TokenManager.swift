//
//  TokenManager.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/10.
//

import Foundation

import FirebaseMessaging
import FirebaseAuth

class TokenManager {
    static let shared = TokenManager()
    
    private init() {}
    
    func getFCMToken(completion: @escaping (String) -> Void) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print(error)
                return
            } else if let token = token {
                completion(token)
            }
        }
    }
    
    func getIdToken(completion: @escaping (String) -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error)
                return
            } else if let idToken = idToken {
                completion(idToken)
            }
        }
    }
}
