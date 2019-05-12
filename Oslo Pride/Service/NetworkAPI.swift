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
                let decodedEvents = try JSONDecoder().decode([Event].self, from: data)
                completion(decodedEvents)
            } catch let err {
                print("failed to fetch events: ", err)
            }
        }.resume()
    }
    
    
    
    
    
}
