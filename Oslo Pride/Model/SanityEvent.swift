//
//  Event.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 12/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import Foundation

fileprivate struct SanityEventRaw: Decodable {
    var _id: String
    var title: String
    var organizer: String
    var ingress: String?
    var description: [SanityBlockDescription]?
    var startingTime: String
    var endingTime: String
    var ticketSaleWebpage: String?
    var prices: [SanityPrice]?
    var ageLimit: String
    var location: SanityLocation?
    var imageURL: String?
    var contactPerson: ContactPerson
    
}

fileprivate struct SanityBlockDescription: Decodable {
    var children: [SanityBlock]?
}

fileprivate struct SanityBlock: Decodable {
    var text: String?
}

struct SanityEvent: Decodable {
    var id: String?
    var title: String?
    var organizer: String?
    var ingress: String?
    var description: String?
    var startingTime: Date?
    var endingTime: Date?
    var ticketSaleWebpage: String?
    var prices: [SanityPrice]?
    var ageLimit: String?
    var location: SanityLocation?
    var imageURL: String?
    var contactPerson: ContactPerson?
    
    init(from decoder: Decoder) {
        do {
            let rawResponse = try SanityEventRaw(from: decoder)
            self.id = rawResponse._id
            self.title = rawResponse.title
            self.organizer = rawResponse.organizer
            self.ingress = rawResponse.ingress
            self.ticketSaleWebpage = rawResponse.ticketSaleWebpage
            self.prices = rawResponse.prices
            self.ageLimit = rawResponse.ageLimit
            self.location = rawResponse.location
            self.imageURL = rawResponse.imageURL
            self.contactPerson = rawResponse.contactPerson
            
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions.update(with: .withInternetDateTime)
            dateFormatter.formatOptions.insert(.withFractionalSeconds)
            self.startingTime = dateFormatter.date(from: rawResponse.startingTime)
            self.endingTime = dateFormatter.date(from: rawResponse.endingTime)
            
            var description = ""
            rawResponse.description?.forEach({ (block) in
                block.children?.forEach({ (b) in
                    description += b.text ?? ""
                })
                description += "\n\n"
            })
            self.description = description
            
        } catch let err {
            print("failed to decode event: ", err)
        }
        
    }

    
}

struct SanityLocation: Decodable {
    var name: String?
    var address: String?
}

struct SanityPrice: Decodable {
    var amount: Int?
    var priceLabel: String?
}

struct ContactPerson: Decodable {
    var name: String
    var epost: String
}
