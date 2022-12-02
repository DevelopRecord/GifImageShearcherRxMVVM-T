//
//  Channel.swift
//  ImageSearcher
//
//  Created by 이재혁 on 2022/12/01.
//

import Foundation

struct GiphyResponse: Decodable {
    var data: [Giphy]?
    var pagination: Pagination?
}

struct Giphy: Decodable {
    var url: String?
    var username: String?
    var title: String?
    var images: Image?
}

struct Pagination: Decodable {
    var totalCount: Int?
    var count: Int?
    var offset: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count = "count"
        case offset = "offset"
    }
}

struct Image: Decodable {
    var fixedWidthSmall: FixedWidthSmall?
    
    enum CodingKeys: String, CodingKey {
        case fixedWidthSmall = "fixed_width_small"
    }
}

struct FixedWidthSmall: Decodable {
    var url: String?
}

struct FixedWidthSmallStill: Decodable {
    var url: String?
}
