//
//  Localization.swift
//  WW-Exercise-01
//
//  Created by administrator on 5/26/22.
//  Copyright © 2022 Weight Watchers. All rights reserved.
//

import Foundation

protocol Localization {
    associatedtype Key
    func localizedString(_ key: Key) -> String
}
