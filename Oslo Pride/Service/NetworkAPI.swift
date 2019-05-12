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
    let host = "http://localhost:3010/api/v1"
    
    var imageCache = [String : Data]()
}

extension NetworkAPI {
    func fetchEvents(completion: @escaping ([Event]) -> ()) {
        guard let url = URL(string: "\(host)/published-events") else { return }
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
                let decodedEvents = try decoder.decode([Event].self, from: data)
                completion(decodedEvents)
            } catch let err {
                print("failed to fetch events: ", err)
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (Data) -> ()) {
        let req = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        URLSession.shared.dataTask(with: req) { (data, response, err) in
            if let err = err {
                print("failed to fetch events: ", err)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else { return }
            guard let data = data else { return }
            self.imageCache[url.absoluteString] = data
            completion(data)
        }.resume()
    }
    
    
    
    
    
}
