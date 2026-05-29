//
//  Comment.swift
//  HackerReader
//
//  Created by mai on 5/27/26.
//

import Foundation

struct Comment: Codable, Identifiable, Hashable {
    let by: String?
    let id: Int
    let kids: [Int]?
    let parent: Int
    let text: String?
    let time: Date
    let type: HNItemType
    let deleted: Bool?
    let dead: Bool?

    var displayText: String { isValid ? textWithoutHTMLTag : "[deleted]" }
    
    var displayAuthor: String { isValid ? by ?? "" : "[deleted]" }
    
    private var isValid: Bool { !(deleted == true || dead == true) }
    
    private var textWithoutHTMLTag: String { text?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression) ?? "" }
}

struct CommentNode: Identifiable {
    let comment: Comment
    let depth: Int
    
    var id: Int { comment.id }
}
