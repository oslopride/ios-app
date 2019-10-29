import Foundation

class NetworkAPI {
    static let shared = NetworkAPI()
    // let host = "https://2ger3rla.api.sanity.io/v1/data/query/prod2019?query=*%5B_type%20%3D%3D%20'event'%20%26%26%20editorialState%20%3D%3D%20'published'%5D%7B%0A%20%20%22imageURL%22%3A%20image.asset-%3Eurl%2C%0A%20%20...%0A%7D"
    
    /*
     *[_type == "event" && editorialState == "published"] {
     "imageURL": image.asset->url,
     "venue" : location.venue->name,
     ...
     }
     */
    let host = "https://2ger3rla.api.sanity.io/v1/data/query/prod2019?query=*%5B_type%20%3D%3D%20%22event%22%20%26%26%20editorialState%20%3D%3D%20%22published%22%5D%20%7B%0A%20%20%22imageURL%22%3A%20image.asset-%3Eurl%2C%0A%20%20%22venue%22%20%3A%20location.venue-%3Ename%2C%0A%20%20...%0A%7D"
    
    let partnerUrl = "https://2ger3rla.api.sanity.io/v1/data/query/prod2019?query=*%5B_type%20%3D%3D%20%22partner%22%5D%20%7B%0A%20%20%22image_url%22%3A%20image.asset-%3Eurl%2C%0A%20%20%22image_preview%22%3A%20image.asset-%3Emetadata.lqip%2C%0A%20%20...%0A%7D"
    
    var imageCache = [String: Data]()
}

extension NetworkAPI {
    func fetchEvents(completion: @escaping ([SanityEvent]?) -> ()) {
        guard let url = URL(string: host) else { return }
        let req = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        URLSession.shared.dataTask(with: req) { data, response, err in
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
                let decodedEvents = try decoder.decode(SanityResponse<[SanityEvent]>.self, from: data)
                
                completion(decodedEvents.result)
            } catch let err {
                print("failed to fetch events: ", err)
            }
        }.resume()
    }
    
    func fetchPartners(completion: @escaping ([SanityPartner]?) -> ()) {
        guard let url = URL(string: partnerUrl) else { return }
        let req = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        URLSession.shared.dataTask(with: req) { data, response, err in
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
                let decodedEvents = try decoder.decode(SanityResponse<[SanityPartner]>.self, from: data)
                completion(decodedEvents.result)
            } catch let err {
                print("failed to fetch events: ", err)
                completion(nil)
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (Data?) -> ()) {
        let req = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        URLSession.shared.dataTask(with: req) { data, response, err in
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
            // self.imageCache[url.absoluteString] = data
            completion(data)
        }.resume()
    }
}
