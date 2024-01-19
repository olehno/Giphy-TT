//
//  Gif.swift
//  Giphy TT
//
//  Created by Artūrs Oļehno on 27/12/2023.
//

import Foundation

struct GifsResponse: Codable {
    let data: [Gif]
}

struct Gif: Codable {
    let id: String
    let type: String
    let title: String?
    let import_datetime: String?
    let images: Images
}

struct Images: Codable {
    let original: Original
}

struct Original: Codable {
    let url: String?
}
