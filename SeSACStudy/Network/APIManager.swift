//
//  APIManager.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/10.
//

import Foundation

import Alamofire
import SwiftyJSON

class APIManager {
    let url = "http://api.sesac.co.kr:1207/v1/user/"
    
    var components = URLComponents(string: "http://api.sesac.co.kr:1207/v1/user/")  // 1
   
    static let shared = APIManager()
    private init() {}

    
    func login(idtoken: String) {
        let headers: HTTPHeaders = ["idtoken": idtoken]
        
        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                
                print("login json", json)
            case .failure(let error):
                print("fail")
                print("login error", error)
            }
            print("outside closure")
        }
    }
    
    func signup(idtoken: String) {
        let headers: HTTPHeaders = ["idtoken": idtoken]
        
        let phoneNumber = URLQueryItem(name: "phoneNumber", value: "\(UserDefaults.standard.string(forKey: "phoneNumber") ?? "")")
        let FCMtoken = URLQueryItem(name: "FCMtoken", value: "\(UserDefaults.standard.string(forKey: "FCMtoken") ?? "")")
        let idtoken = URLQueryItem(name: "idtoken", value: "\(UserDefaults.standard.string(forKey: "idtoken") ?? "")")
        let nick = URLQueryItem(name: "nick", value: "\(UserDefaults.standard.string(forKey: "nick") ?? "")")
        let birth = URLQueryItem(name: "birth", value: "\(UserDefaults.standard.string(forKey: "birth") ?? "")")
        let email = URLQueryItem(name: "email", value: "\(UserDefaults.standard.string(forKey: "email") ?? "")")
        let gender = URLQueryItem(name: "gender", value: "\(UserDefaults.standard.integer(forKey: "gender"))")
        components?.queryItems = [phoneNumber, FCMtoken, idtoken, nick, birth, email, gender]
        guard let url = components?.url else { return }

        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            
            case .success(let data):
                let json = JSON(data)
                
                print("sign up json", json)
            case .failure(let error):
                print("sign up fail")
                print("error", error)
            }
            print("sign up outside closure")
        }
    }
    struct Params: Encodable {
        let phoneNumber: String
        let FCMtoken: String
        let nick: String
        let birth: String
        let gender: String
    }
}
