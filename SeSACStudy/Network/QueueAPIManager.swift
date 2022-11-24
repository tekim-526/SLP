//
//  QueueAPIManager.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/18.
//

import Foundation

import Alamofire
import SwiftyJSON

class QueueAPIManager {
   
    static let shared = QueueAPIManager()
    private init() {}
    
    func searchNearPeople(idtoken: String, lat: Double, long: Double, completion: @escaping (GetNearPeopleData?, Int?) -> Void) {
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
                    completion(data, response.response?.statusCode)
                    dump(data)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(_):
                completion(nil, response.response?.statusCode)
            }
        }
    }
    
    func searchNearPeopleWithMyStudy(idtoken: String, lat: Double, long: Double, studylist: [String], completion: @escaping (Int?) -> Void) {
        let url = BaseURL.baseURL + "v1/queue"

        let headers: HTTPHeaders = ["accept": "application/json", "idtoken": idtoken]
        let encoder = URLEncoding(arrayEncoding: .noBrackets)
       
        let parameters: [String: Any] = [
            "long": long,
            "lat": lat,
            "studylist": studylist
        ]
        
//        let parameters = NearPeopleWithStudy(lat: long, long: lat, studylist: studylist)
        
        AF.request(url, method: .post, parameters: parameters, encoding: encoder, headers: headers).validate().response { response in
            switch response.result {
            case .success(_):
                completion(response.response?.statusCode)
             
            case .failure(_):
                completion(response.response?.statusCode)
            }
            print("STATUS CODE :", response.response?.statusCode ?? -1)
        }
    }
}
