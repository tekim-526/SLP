//
//  APIManager.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/10.
//

import Foundation

import Alamofire
import SwiftyJSON



class UserAPIManager {
   
    static let shared = UserAPIManager()
    private init() {}

    
    func login(idtoken: String, completion: @escaping (MyInFoData? ,Bool, AFError?) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idtoken]
        let urlString = BaseURL.baseURL + "v1/user"
        
        AF.request(urlString, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(MyInFoData.self, from: data)
                    print("login")
                    completion(data, true, nil)
                    dump(data)
                } catch {
                    print(error)
                }
            
                print(response.response?.statusCode ?? 0)
            case .failure(let error):
                print("login error", error)
                completion(nil, false, error)
                print(error.responseCode ?? 0)
            }
        }
    }
    
    func signup(idtoken: String, completion: @escaping (Int?) -> Void) {
        let urlString = BaseURL.baseURL + "v1/user"
        let components = URLComponents(string: urlString)

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
        
        let urlString = BaseURL.baseURL + "v1/user/mypage"
        let components = URLComponents(string: urlString)

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
    
    func withdraw(idtoken: String, completion: @escaping () -> Void) {
        let urlString = BaseURL.baseURL + "v1/user/withdraw"
        let components = URLComponents(string: urlString)

        let headers: HTTPHeaders = ["idtoken": idtoken]
        guard let url = components?.url else { return }
        
        AF.request(url, method: .post, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(_):
                print("withdraw success")
                completion()
            case .failure(let error):
                print("withdraw fail")
                print("error", error)
            }
            print("withdraw outside closure")
        }
    }
  
}
