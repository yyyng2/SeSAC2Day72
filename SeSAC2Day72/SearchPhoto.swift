//
//  SearchPhoto.swift
//  SeSAC2Day72
//
//  Created by Y on 2022/10/20.
//

import Foundation

struct SearchPhoto: Codable, Hashable {
     
    let total, totalPages: Int
    let results: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
