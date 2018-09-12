//
//  API.swift
//  iOSTestEokoe
//
//  Created by Fernanda de Lima on 11/09/2018.
//  Copyright © 2018 FeLima. All rights reserved.
//

import Foundation
import Alamofire

enum Endpoint {
    
    case users
    case user(Int)
    
    func pathEndpoint() ->String {
        switch self {
        case .users:
            return "users?start=120&limit=90"
        case .user(let id):
            return "user/\(id)"
        }
    }
    
}


class API{
    
    static let baseUrl = "http://testmobiledev.eokoe.com/"
    
    static func get <T: Any>
        (_ type: T.Type,
         endpoint: Endpoint,
         success:@escaping (_ item: T) -> Void,
         fail:@escaping (_ error: Error) -> Void) -> Void where T:Codable {
        
//        let headers: HTTPHeaders = [
//            "X-API-Key": "d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35"
//        ]
        
        let url = "\(baseUrl)\(endpoint.pathEndpoint())"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35", forHTTPHeaderField: "X-API-Key")
        
        //create session to connection
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                
                //verify response
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200{ //it's ok
                        //verify if have response data
                        if let data = data{
                            let jsonDecoder = JSONDecoder()
                            let jsonArray = try jsonDecoder.decode(type.self, from: data)
                            success(jsonArray)
                        }
                    }
                }
                
            } catch {
                fail(error)
            }
            
        })
        
        task.resume()
    }
}
