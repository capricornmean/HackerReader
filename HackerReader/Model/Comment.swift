//
//  Comment.swift
//  HackerReader
//
//  Created by mai on 5/27/26.
//

import Foundation

struct Comment: Decodable, Identifiable, Hashable {
    let by: String?
    let id: Int
    let kids: [Int]?
    let parent: Int
    let text: String?
    let time: Date
    let type: HNItemType
    let deleted: Bool?
    let dead: Bool?
}

struct CommentNode: Identifiable {
    let comment: Comment
    let depth: Int
    
    var id: Int { comment.id }
    
    func isValid() -> Bool {
        !(comment.deleted == true || comment.dead == true)
    }
    
    func getText() -> String {
        comment.text?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression) ?? ""
    }
}
