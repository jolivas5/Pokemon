//
//  APIFailure.swift
//

import Foundation

enum APIFailure: Error {
    case decodingError
    case URLError
    case captured(Error)
}
