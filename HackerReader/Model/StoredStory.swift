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
    
    init(by: String, descendants: Int? = nil, id: Int, kids: [Int]? = nil, score: Int, time: Date, title: String, type: HNItemType, url: String? = nil) {
        self.by = by
        self.descendants = descendants
        self.id = id
        self.kids = kids
        self.score = score
        self.time = time
        self.title = title
        self.type = type
        self.url = url
    }
}

extension StoredStory {
    convenience init(from story: Story) {
        self.init(by: story.by,
                  descendants: story.descendants,
                  kids: story.kids,
                  score: story.score,
                  time: story.time,
                  title: story.title,
                  type: story.type,
                  url: story.url,
                  id: story.id)
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
