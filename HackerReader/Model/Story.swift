//
//  Story.swift
//  HackerReader
//
//  Created by mai on 5/24/26.
//

import Foundation

struct Story: Decodable, Identifiable, Hashable {
    let by: String
    let descendants: Int?
    let id: Int
    let kids: [Int]?
    let score: Int
    let time: Date
    let title: String
    let type: Type
    let url: String?
}
