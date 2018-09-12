//
//  API.swift
//  iOSTestEokoe
//
//  Created by Fernanda de Lima on 11/09/2018.
//  Copyright © 2018 FeLima. All rights reserved.
//

import Foundation
import UIKit

enum Endpoint {
    
    case users(Int)
    case user(Int)
    case upload
    
    func pathEndpoint() ->String {
        switch self {
        case .users(let start):
            return "users?start=\(start)&limit=20"
        case .user(let id):
            return "user/\(id)"
        case .upload:
            return "upload"
        }
    }
    
}


class API{
    
    static var page = 0
    
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
    
    static func post
        (image:UIImage,
         endpoint: Endpoint,
         success:@escaping (_ msg:String ) -> Void,
         fail:@escaping (_ error: Error) -> Void) -> Void{
        
        let url = "\(baseUrl)\(endpoint.pathEndpoint())"
        let imageData = UIImageJPEGRepresentation(image, 1)
        let boundary = generateBoundaryString()
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35", forHTTPHeaderField: "X-API-Key")
        request.httpBody = createBodyWithParameters(parameters: nil, filePathKey: "image", imageDataKey: imageData!, boundary: boundary)
        
        //create session to connection
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                
                print("======> response \(response)")
                print("======> data \(data)")

                //verify response
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201{ //it's ok
                        //verify if have response data
                       success("Foto enviada com sucesso")
                    }
                }
                
            } catch {
                print("======> error \(error.localizedDescription)")
                fail(error)
            }
            
        })
        
        task.resume()
    }
    
    static func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        var body = Data();

        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageDataKey)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        return body
    }
    
    static func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
}
