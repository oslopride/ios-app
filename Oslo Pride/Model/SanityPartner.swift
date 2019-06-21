//
//  SanityPartner.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 21/06/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import Foundation

struct SanityPartner: Decodable {
    var _id: String?
    var name: String?
    var imageUrl: String?
    var partnerUrl: String?
    var type: String?
    var imagePreview: String?
    
    var imageData: Data?
}
