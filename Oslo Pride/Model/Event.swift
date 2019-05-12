//
//  Event.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 12/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import Foundation

struct Event: Decodable {
    var title: String?
    var imageURL: String?
}

struct SanityImage: Decodable {
    var asset: SanityAsset?
}

struct SanityAsset: Decodable {
    var _ref: String?
    var _type: String?
}
