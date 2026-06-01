//
//  StoredStory.swift
//  HackerReader
//
//  Created by mai on 5/29/26.
//

import Foundation
import SwiftData

@Model
final class StoredStory {
    var by: String
    var descendants: Int?
    @Attribute(.unique) var id: Int
    var kids: [Int]?
    var score: Int
    var time: Date
    var title: String
    var type: HNItemType
    var url: String?
    var rank: Int
    @Relationship(deleteRule: .cascade, inverse: \StoredComment.story) var comments: [StoredComment] = []
    
    init(by: String, descendants: Int? = nil, id: Int, kids: [Int]? = nil, score: Int, time: Date, title: String, type: HNItemType, url: String? = nil, rank: Int, comments: [StoredComment] = []) {
        self.by = by
        self.descendants = descendants
        self.id = id
        self.kids = kids
        self.score = score
        self.time = time
        self.title = title
        self.type = type
        self.url = url
        self.rank = rank
        self.comments = comments
    }
}

extension StoredStory {
    convenience init(from story: Story, rank: Int) {
        self.init(by: story.by,
                  descendants: story.descendants,
                  id: story.id,
                  kids: story.kids,
                  score: story.score,
                  time: story.time,
                  title: story.title,
                  type: story.type,
                  url: story.url,
                  rank: rank)
    }
    
    var asStory: Story {
        .init(by: by,
              descendants: descendants,
              id: id,
              kids: kids,
              score: score,
              time: time,
              title: title,
              type: type,
              url: url)
    }
}
