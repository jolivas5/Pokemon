//
//  StringFormatterTests.swift
//  WW-Exercise-01Tests
//
//  
//  
//

import XCTest
@testable import WW_Exercise_01

final class StringFormatterTests: XCTestCase {

    func testCharRemoval_valid() {

        let charsToRemove = "[\\\"]"

        let sanitizeArray = [
            "[\\\"contentTags.food_cooking method.tags:Grilling\\\"]",
            "[\\\"contentTags.food_other.tags:Quick & Easy\\\"]",
            "[\\\"contentTags.food_cooking method.tags:No-Cook\\\"]",
            "[\\\"contentTags.food_other.tags:Family-Friendly\\\"]",
            "[\\\"contentTags.food_season.tags:Summer\\\"], [\\\"contentTags.food_season.tags:Spring\\\"]",
            "[\\\"contentTags.food_cuisines.tags:American\\\"]",
            "[\\\"contentTags.food_cuisines.tags:Italian\\\"]",
            ""
        ]

        let sanitizedArray = [
            "contentTags.food_cooking method.tags:Grilling",
            "contentTags.food_other.tags:Quick & Easy",
            "contentTags.food_cooking method.tags:No-Cook",
            "contentTags.food_other.tags:Family-Friendly",
            "contentTags.food_season.tags:Summer, contentTags.food_season.tags:Spring",
            "contentTags.food_cuisines.tags:American",
            "contentTags.food_cuisines.tags:Italian",
            ""
        ]

        zip(sanitizeArray, sanitizedArray).forEach { (sanitize, expected) in
          XCTAssertEqual(sanitize.stringByRemovingSpecifiedChars(charsToRemove), expected)
        }
    }
}
