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

    
    func login(idtoken: String, completion: @escaping (MyInFoData? ,Bool, AFError?) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idtoken]
        
        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let background = json["background"].intValue
                let sesac = json["sesac"].intValue
                let nick = json["nick"].stringValue
                let reputation = json["reputation"].arrayObject as! [Int]
                let gender = json["gender"].intValue
                let study = json["study"].stringValue
                let searchable = json["searchable"].intValue
                let ageMin = json["ageMin"].intValue
                let ageMax = json["ageMax"].intValue
            
                let myInfoData = MyInFoData(background: background, sesac: sesac, nick: nick, reputation: reputation, gender: gender, study: study, searchable: searchable, ageMin: ageMin, ageMax: ageMax)
                print(myInfoData)
                print(response.response?.statusCode ?? 0)
                completion(myInfoData, true, nil)
            case .failure(let error):
                print("login error", error)
                completion(nil, false, error)
                print(error.responseCode ?? 0)
            }
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
                completion(response.response?.statusCode)
            case .failure(_):
                completion(response.response?.statusCode)
            }
        }
    }
    
    func myPage(idtoken: String, searchable: Int = 0, ageMin: Int = 0, ageMax: Int = 0, gender: Int = 0, study: String?, completion: @escaping (Int?) -> Void) {
        let components = URLComponents(string: "http://api.sesac.co.kr:1207/v1/user/mypage")

        let headers: HTTPHeaders = ["idtoken": idtoken, "Content-Type": "application/x-www-form-urlencoded"]
        
        let json: [String: Any] = [
            "searchable": searchable,
            "ageMin": ageMin,
            "ageMax": ageMax,
            "gender": gender,
            "study": study ?? ""
        ]

        guard let url = components?.url else { return }
        AF.request(url, method: .put, parameters: json, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(_):
//                let json = JSON(data)
                completion(response.response?.statusCode)
            case .failure(_):
                completion(response.response?.statusCode)
            }
        }
    }
    
    func withdraw(idtoken: String) {
        let components = URLComponents(string: "http://api.sesac.co.kr:1207/v1/user/withdraw")

        let headers: HTTPHeaders = ["idtoken": idtoken]
        guard let url = components?.url else { return }
        
        AF.request(url, method: .post, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(_):
                print("withdraw success")
            case .failure(let error):
                print("withdraw fail")
                print("error", error)
            }
            print("withdraw outside closure")
        }
    }
  
}
