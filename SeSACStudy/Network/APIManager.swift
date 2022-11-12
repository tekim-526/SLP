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
    let url = "http://api.sesac.co.kr:1207/v1/user"
    
   
    static let shared = APIManager()
    private init() {}

    
    func login(idtoken: String, completion: @escaping (Bool, AFError?) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idtoken]
        
        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                completion(true, nil)
            case .failure(let error):
                print("login error", error)
                completion(false, error)
                print(error.responseCode)
            }
            print("outside closure")
        }
    }
    
    func signup(idtoken: String, completion: @escaping (Int?) -> Void) {
        let components = URLComponents(string: "http://api.sesac.co.kr:1207/v1/user")

        let headers: HTTPHeaders = ["idtoken": idtoken, "Content-Type": "application/x-www-form-urlencoded"]
        
        let json: [String: Any] = ["phoneNumber": UserDefaults.standard.string(forKey: "phoneNumber") ?? "",
                                   "FCMtoken": UserDefaults.standard.string(forKey: "FCMtoken") ?? "",
                                   "nick": UserDefaults.standard.string(forKey: "nick") ?? "",
                                   "birth": UserDefaults.standard.string(forKey: "birth") ?? "",
                                   "email": UserDefaults.standard.string(forKey: "email") ?? "",
                                   "gender": UserDefaults.standard.integer(forKey: "gender") ]

        guard let url = components?.url else { return }
        AF.request(url, method: .post, parameters: json, headers: headers).validate().responseData { response in
            switch response.result {
            
            case .success(let data):
                let json = JSON(data)
                print("sign up json", json)
                completion(response.response?.statusCode)
            case .failure(_):
                print("sign up fail")
                completion(response.response?.statusCode)
            }
            print("sign up outside closure")
        }
    }
    
    func withdraw(idtoken: String) {
        let components = URLComponents(string: "http://api.sesac.co.kr:1207/v1/user/withdraw")

        let headers: HTTPHeaders = ["idtoken": idtoken]
        guard let url = components?.url else { return }
        
        AF.request(url, method: .post, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(_):
                print("withdraw succes")
            case .failure(let error):
                print("withdraw fail")
                print("error", error)
            }
            print("withdraw outside closure")
        }
    }
    private func makeSignupQueryItems() -> [URLQueryItem] {
        UserDefaults.standard.set("TaeSu Kim", forKey: "nick")
        print(UserDefaults.standard.string(forKey: "phoneNumber"),
              UserDefaults.standard.string(forKey: "FCMtoken"),
              UserDefaults.standard.string(forKey: "nick"),
              UserDefaults.standard.string(forKey: "birth"),
              UserDefaults.standard.string(forKey: "email"),
              UserDefaults.standard.integer(forKey: "gender"),
              "\(UserDefaults.standard.string(forKey: "idtoken") ?? "")",
              
              separator: "\n")
        let phoneNumber = URLQueryItem(name: "phoneNumber", value: UserDefaults.standard.string(forKey: "phoneNumber") ?? "")
        let FCMtoken = URLQueryItem(name: "FCMtoken", value: UserDefaults.standard.string(forKey: "FCMtoken") ?? "")
        let nick = URLQueryItem(name: "nick", value: UserDefaults.standard.string(forKey: "nick") ?? "")
        let birth = URLQueryItem(name: "birth", value: UserDefaults.standard.string(forKey: "birth") ?? "")
        let email = URLQueryItem(name: "email", value: UserDefaults.standard.string(forKey: "email") ?? "")
        let gender = URLQueryItem(name: "gender", value: "\(UserDefaults.standard.integer(forKey: "gender"))")
        
        return [phoneNumber, FCMtoken, nick, birth, email, gender]
    }
    
}
