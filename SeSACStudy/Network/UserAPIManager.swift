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

    
    func login(idtoken: String, completion: @escaping (Result<MyInFoData ,NetworkStatus>) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idtoken]
        let urlString = BaseURL.baseURL + "v1/user"
        
        AF.request(urlString, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(MyInFoData.self, from: data)
                    completion(.success(data))
                } catch {
                    print(error)
                }                
            case .failure(_):
                guard let status = response.response?.statusCode else {return}
                guard let status = NetworkStatus(rawValue: status) else {return}
                completion(.failure(status))
            }
        }
    }
    
    func signup(idtoken: String, completion: @escaping (NetworkStatus) -> Void) {
        let urlString = BaseURL.baseURL + "v1/user"
        let components = URLComponents(string: urlString)

        let headers: HTTPHeaders = ["idtoken": idtoken, "Content-Type": "application/x-www-form-urlencoded"]
        

        let parameters = SignUp(
            phoneNumber: UserDefaults.standard.string(forKey: UserDefaultsKey.phoneNumber.rawValue) ?? "",
            FCMtoken: UserDefaults.standard.string(forKey: UserDefaultsKey.FCMtoken.rawValue) ?? "",
            nick: UserDefaults.standard.string(forKey: UserDefaultsKey.nick.rawValue) ?? "",
            birth: UserDefaults.standard.string(forKey: UserDefaultsKey.birth.rawValue) ?? "",
            email: UserDefaults.standard.string(forKey: UserDefaultsKey.email.rawValue) ?? "",
            gender: UserDefaults.standard.integer(forKey: UserDefaultsKey.gender.rawValue)
        )
        
        guard let url = components?.url else { return }
        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().responseData { response in
            guard let statusCode = response.response?.statusCode else { return }
            guard let status = NetworkStatus(rawValue: statusCode) else { return }
            completion(status)
        }
    }
    
  
    
    func myPage(idtoken: String, searchable: Int = 0, ageMin: Int = 0, ageMax: Int = 0, gender: Int = 0, study: String?, completion: @escaping (NetworkStatus) -> Void) {
        
        let urlString = BaseURL.baseURL + "v1/user/mypage"
        let components = URLComponents(string: urlString)

        let headers: HTTPHeaders = ["idtoken": idtoken, "Content-Type": "application/x-www-form-urlencoded"]
        
        let parameters = MyPage(searchable: searchable, ageMin: ageMin, ageMax: ageMax, gender: gender, study: study ?? "")
        
        guard let url = components?.url else { return }
        AF.request(url, method: .put, parameters: parameters, headers: headers).validate().responseData { response in
            guard let statusCode = response.response?.statusCode else { return }
            guard let status = NetworkStatus(rawValue: statusCode) else { return }
            completion(status)
        }
    }
    
    func withdraw(idtoken: String, completion: @escaping (NetworkStatus) -> Void) {
        let urlString = BaseURL.baseURL + "v1/user/withdraw"
        let components = URLComponents(string: urlString)

        let headers: HTTPHeaders = ["idtoken": idtoken]
        guard let url = components?.url else { return }
        
        AF.request(url, method: .post, headers: headers).validate().responseData { response in
            guard let statusCode = response.response?.statusCode else { return }
            guard let status = NetworkStatus(rawValue: statusCode) else { return }
            completion(status)
        }
    }
  
}
