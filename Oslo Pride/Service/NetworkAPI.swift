//
//  NetworkAPI.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 12/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import Foundation

class NetworkAPI {
    static let shared = NetworkAPI()
    //let host = "http://localhost:3010/api/v1"
    //let host = "http://192.168.58.82:3010/api/v1"
    //let host = "http://10.0.1.100:3010/api/v1"
    //let host = "http://169.254.41.208:3010/api/v1"
    
    //let host = "https://2ger3rla.api.sanity.io/v1/data/query/prod2019?query=*[_type == \"event\"]&$editorialState=\"published\"{\"imageURL\": image.asset->url, ...}"
    
    let host = "https://2ger3rla.api.sanity.io/v1/data/query/prod2019?query=*%5B_type%20%3D%3D%20'event'%20%26%26%20editorialState%20%3D%3D%20'published'%5D%7B%0A%20%20%22imageURL%22%3A%20image.asset-%3Eurl%2C%0A%20%20...%0A%7D"
    var imageCache = [String : Data]()
}

extension NetworkAPI {
    func fetchEvents(completion: @escaping ([SanityEvent]?) -> ()) {
        guard let url = URL(string: host) else { return }
        let req = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        URLSession.shared.dataTask(with: req) { (data, response, err) in
            if let err = err {
                print("Failed to fetch events: ", err)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else { return }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedEvents = try decoder.decode(SanityResponse.self, from: data)
                
                completion(decodedEvents.result)
            } catch let err {
                print("failed to fetch events: ", err)
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (Data?) -> ()) {
        let req = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        URLSession.shared.dataTask(with: req) { (data, response, err) in
            if let err = err {
                print("failed to fetch events: ", err)
                completion(nil)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(nil)
                return
            }
            guard response.statusCode == 200 else {
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            //self.imageCache[url.absoluteString] = data
            completion(data)
        }.resume()
    }
    
    
    
    
    
}
