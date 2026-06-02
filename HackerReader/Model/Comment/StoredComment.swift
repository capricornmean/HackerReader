//
//  StoredComment.swift
//  HackerReader
//
//  Created by mai on 5/31/26.
//

import Foundation
import SwiftData

@Model
final class StoredComment {
    var by: String?
    @Attribute(.unique) var id: Int
    var kids: [Int]?
    var parent: Int
    var text: String?
    var time: Date
    var type: HNItemType
    var deleted: Bool?
    var dead: Bool?
    var depth: Int
    var rank: Int
    var story: StoredStory?
    
    init(by: String? = nil, id: Int, kids: [Int]? = nil, parent: Int, text: String? = nil, time: Date, type: HNItemType, deleted: Bool? = nil, dead: Bool? = nil, depth: Int, rank: Int, story: StoredStory? = nil) {
        self.by = by
        self.id = id
        self.kids = kids
        self.parent = parent
        self.text = text
        self.time = time
        self.type = type
        self.deleted = deleted
        self.dead = dead
        self.depth = depth
        self.rank = rank
        self.story = story
    }
}

extension StoredComment {
    convenience init(from comment: Comment, depth: Int, rank: Int, story: StoredStory? = nil) {
        self.init(by: comment.by,
                  id: comment.id,
                  kids: comment.kids,
                  parent: comment.parent,
                  text: comment.text,
                  time: comment.time,
                  type: .comment,
                  deleted: comment.deleted,
                  dead: comment.dead,
                  depth: depth,
                  rank: rank,
                  story: story)
    }
    
    var asCommentNode: CommentNode {
        let comment = Comment(by: by,
                              id: id,
                              kids: kids,
                              parent: parent,
                              text: text,
                              time: time,
                              type: type,
                              deleted: deleted,
                              dead: dead)
        return CommentNode(comment: comment, depth: depth)
    }
}
