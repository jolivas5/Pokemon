//
//  LTK.swift

import Foundation

struct LTK: Codable {
    let id: String?
    let hash: String?
    let status: String?
    let caption: String?
    let share_url: String?
    let profile_id: String?
    let hero_image: String?
    let date_created: String?
    let date_updated: String?
    let hero_image_width: Int?
    let hero_image_height: Int?
    let video_media_id: String?
    let date_scheduled: String?
    let date_published: String?
    let profile_user_id: String?
    let product_ids: [String]?
}

extension LTK: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
    }
    static func == (lhs: LTK, rhs: LTK) -> Bool {
        lhs.hash == rhs.hash
    }
}
