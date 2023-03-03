//
//  QueueAPIManager.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/18.
//

import Foundation

import Alamofire

@frozen
enum MyStudy: String {
    case studyrequest
    case studyaccept
    case dodge
}

class QueueAPIManager {
    
    static let shared = QueueAPIManager()
    private let idtoken: String
    private init() {
        let idtoken = UserDefaults.standard.string(forKey: UserDefaultsKey.idtoken.rawValue) ?? ""
        self.idtoken = idtoken
    }
    
    func searchNearPeople(lat: Double, long: Double, completion: @escaping (Result<GetNearPeopleData, NetworkStatus>) -> Void) {
        let urlString = BaseURL.baseURL + "v1/queue/search"
        let components = URLComponents(string: urlString)

        let headers: HTTPHeaders = ["idtoken": idtoken, "Content-Type": "application/x-www-form-urlencoded"]
        
        let parameters = NearPeople(lat: lat, long: long)
        guard let url = components?.url else { return }
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseData { response in
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
    
    func searchNearPeopleWithMyStudy(lat: Double, long: Double, studylist: [String], completion: @escaping (NetworkStatus) -> Void) {
        let url = BaseURL.baseURL + "v1/queue"

        let headers: HTTPHeaders = ["idtoken": idtoken]

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
    
    func stopFind(completion: @escaping (NetworkStatus) -> Void) {
        let url = BaseURL.baseURL + "v1/queue"
        
        let headers: HTTPHeaders = ["idtoken": idtoken]
        AF.request(url, method: .delete, headers: headers).validate().response { response in
            guard let statusCode = response.response?.statusCode else { return }
            guard let status = NetworkStatus(rawValue: statusCode) else { return }
            completion(status)
        }
    }
    
    func myQueueState(completion: @escaping (Result<MyQueueState, NetworkStatus>) -> Void) {
        let url = BaseURL.baseURL + "v1/queue/myQueueState"
        let headers: HTTPHeaders = ["idtoken": idtoken]
        AF.request(url, method: .get, headers: headers).validate(statusCode: 200...200).response { response in
            switch response.result {
            case .success(let result):
                guard let result else {return}
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(MyQueueState.self, from: result)
                    completion(.success(data))
                } catch {
                    print("errorCatched")
                    print(error)
                }
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                guard let status = NetworkStatus(rawValue: statusCode) else { return }
                completion(.failure(status))
            }
            
        }
    }
    
    func myStudy(idtoken: String = UserDefaults.standard.string(forKey: UserDefaultsKey.idtoken.rawValue) ?? "", method: MyStudy = .studyrequest, otheruid: String, completion: @escaping (NetworkStatus) -> Void) {
        let url = BaseURL.baseURL + "v1/queue/\(method.rawValue)"
        let headers: HTTPHeaders = ["idtoken": idtoken]
       
        let parameters = RequestStudy(otheruid: otheruid)
                
        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().response { response in
            guard let statusCode = response.response?.statusCode else { return }
            guard let status = NetworkStatus(rawValue: statusCode) else { return }
            completion(status)
        }
    }
}
