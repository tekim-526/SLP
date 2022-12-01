//
//  ChatAPIManager.swift
//  SeSACStudy
//
//  Created by Kim TaeSoo on 2022/11/29.
//

import Foundation

import Alamofire
import SwiftyJSON

class ChatAPIManager {
    static let shared = ChatAPIManager()
    
    private init() {}
    
    func sendChat(to: String, chat: String, completion: @escaping (Result<Payload, NetworkStatus>) -> Void) {
        guard let id = UserDefaults.standard.string(forKey: UserDefaultsKey.idtoken.rawValue) else { return }
        let url = BaseURL.baseURL + "v1/chat/\(to)"
        let header: HTTPHeaders = ["idtoken": id]
        let parameters = ["chat" : chat]
        
        AF.request(url ,method: .post, parameters: parameters, headers: header).validate().response { response in
            switch response.result {
            case .success(let result):
                let decoder = JSONDecoder()
                guard let result else { return }
                do {
                    let data = try decoder.decode(Payload.self, from: result)
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
    
    func fetchChat(otheruid from: String, lastchatDate: String, completion: @escaping (Result<ChatData, NetworkStatus>) -> Void) {
        guard let id = UserDefaults.standard.string(forKey: UserDefaultsKey.idtoken.rawValue) else { return }
        let url = BaseURL.baseURL + "v1/chat/\(from)?lastchatDate=\(lastchatDate)"
        let header: HTTPHeaders = ["idtoken": id]
        
        AF.request(url ,method: .get, headers: header).validate().response { response in
            switch response.result {
            case .success(let result):
                let decoder = JSONDecoder()
                guard let result else { return }
                do {
                    let data = try decoder.decode(ChatData.self, from: result)
                    completion(.success(data))
                } catch {
                    print("chat decoding fail :", error.localizedDescription)
                }
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                guard let status = NetworkStatus(rawValue: statusCode) else { return }
                completion(.failure(status))
            }
        }
    }
}
