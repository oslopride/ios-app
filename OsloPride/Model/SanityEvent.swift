import Foundation

struct SanityResponse<T: Decodable>: Decodable {
    var ms: Int?
    var query: String?
    var result: T?
}

private struct SanityEventRaw: Decodable {
    var _id: String
    var title: String
    var organizer: String
    var category: String
    var ingress: String?
    var description: [SanityBlockDescription]?
    var startingTime: String
    var endingTime: String
    var ticketSaleWebpage: String?
    var prices: [SanityPrice]?
    var ageLimit: String
    var location: SanityLocation?
    var venue: String?
    var imageURL: String?
    var contactPerson: ContactPerson
    var deafInterpretation: Bool?
    var accessible: Bool?
    var free: Bool?
}

private struct SanityBlockDescription: Decodable {
    var children: [SanityBlock]?
}

private struct SanityBlock: Decodable {
    var text: String?
}

struct SanityEvent: Decodable {
    var id: String?
    var title: String?
    var organizer: String?
    var category: String?
    var ingress: String?
    var description: String?
    var startingTime: Date?
    var endingTime: Date?
    var ticketSaleWebpage: String?
    var prices: [SanityPrice]?
    var ageLimit: String?
    var location: SanityLocation?
    var venue: String?
    var imageURL: String?
    var contactPerson: ContactPerson?
    var deafInterpretation: Bool?
    var accessible: Bool?
    var free: Bool?
    
    init(from decoder: Decoder) {
        do {
            let rawResponse = try SanityEventRaw(from: decoder)
            id = rawResponse._id
            title = rawResponse.title
            organizer = rawResponse.organizer
            category = rawResponse.category
            ingress = rawResponse.ingress
            ticketSaleWebpage = rawResponse.ticketSaleWebpage
            prices = rawResponse.prices
            ageLimit = rawResponse.ageLimit
            location = rawResponse.location
            venue = rawResponse.venue
            accessible = rawResponse.accessible
            deafInterpretation = rawResponse.deafInterpretation
            free = rawResponse.free
            
            if let urlString = rawResponse.imageURL, urlString.count > 0 {
                imageURL = rawResponse.imageURL! + "?w1024&h=768"
            } else {
                imageURL = ""
            }
            
            contactPerson = rawResponse.contactPerson
            
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions.update(with: .withInternetDateTime)
            dateFormatter.formatOptions.insert(.withFractionalSeconds)
            startingTime = dateFormatter.date(from: rawResponse.startingTime)
            endingTime = dateFormatter.date(from: rawResponse.endingTime)
            
            var description = ""
            rawResponse.description?.forEach { block in
                block.children?.forEach { b in
                    description += b.text ?? ""
                }
                description += "\n\n"
            }
            self.description = description
            
        } catch let err {
            print("failed to decode event: ", err)
        }
    }
}

struct SanityLocation: Decodable {
    var name: String?
    var address: String?
    // var venue: String?
}

struct SanityPrice: Decodable {
    var amount: Int?
    var priceLabel: String?
}

struct ContactPerson: Decodable {
    var name: String
    var epost: String
}
