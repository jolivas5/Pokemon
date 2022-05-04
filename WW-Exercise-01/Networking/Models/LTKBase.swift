//
//

import Foundation

struct LTKBase: Codable {
    let meta: Meta?
    let ltks: [LTK]?
    let profiles: [Profile]?
    let products: [Product]?
    let media_objects: [String]?
}

extension LTKBase: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ltks)
    }
    
    static func == (lhs: LTKBase, rhs: LTKBase) -> Bool {
        lhs.ltks == rhs.ltks
    }
}
