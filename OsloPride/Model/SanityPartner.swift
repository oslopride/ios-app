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
