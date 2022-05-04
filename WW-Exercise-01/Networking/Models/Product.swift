//
//  Product.swift
//

import Foundation

struct Product: Codable {
    let id: String?
    let links: Links?
    let ltk_id: String?
    let matching: String?
    let hyperlink: String?
    let image_url: String?
    let product_details_id: String?
}

extension Product: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
}
