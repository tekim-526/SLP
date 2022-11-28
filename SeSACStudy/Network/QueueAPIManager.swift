//
//  QueueAPIManager.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/18.
//

import Foundation

import Alamofire
import SwiftyJSON

enum MyStudy: String {
    case studyrequest
    case studyaccept
    case dodge
}

class QueueAPIManager {
   
    static let shared = QueueAPIManager()
    private init() {}
    
    func searchNearPeople(idtoken: String, lat: Double, long: Double, completion: @escaping (Result<GetNearPeopleData, NetworkStatus>) -> Void) {
        let urlString = BaseURL.baseURL + "v1/queue/search"
        let components = URLComponents(string: urlString)

        let headers: HTTPHeaders = ["idtoken": idtoken, "Content-Type": "application/x-www-form-urlencoded"]
        
        let parameters = NearPeople(lat: lat, long: long)
        guard let url = components?.url else { return }
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(GetNearPeopleData.self, from: data)
                    completion(.success(data))
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                guard let status = NetworkStatus(rawValue: statusCode) else { return }
                completion(.failure(status))
            }
        }
    }
    
    func searchNearPeopleWithMyStudy(idtoken: String, lat: Double, long: Double, studylist: [String], completion: @escaping (NetworkStatus) -> Void) {
        let url = BaseURL.baseURL + "v1/queue"

        let headers: HTTPHeaders = ["accept": "application/json", "idtoken": idtoken]
        let encoder = URLEncoding(arrayEncoding: .noBrackets)
       
        let parameters: [String: Any] = [
            "long": long,
            "lat": lat,
            "studylist": studylist
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: encoder, headers: headers).validate().response { response in
            guard let statusCode = response.response?.statusCode else { return }
            guard let status = NetworkStatus(rawValue: statusCode) else { return }
            completion(status)
        }
    }
    
    func myStudy(idtoken: String, method: MyStudy = .studyrequest, otheruid: String, completion: @escaping (NetworkStatus) -> Void) {
        let url = BaseURL.baseURL + "v1/queue/\(method.rawValue)"
        print("url :", url)
        let headers: HTTPHeaders = ["accept": "application/json", "idtoken": idtoken]
       
        let parameters = RequestStudy(otheruid: otheruid)
                
        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().response { response in
            guard let statusCode = response.response?.statusCode else { return }
            guard let status = NetworkStatus(rawValue: statusCode) else { return }
            completion(status)
        }
    }
}
