//
//  GeneralHelpers.swift
//  HackerReader
//
//  Created by mai on 6/4/26.
//

import Foundation

struct GeneralHelpers {
    static func makeStory(id: Int) -> Story {
        Story(by: "someone", descendants: nil, id: id, kids: nil, score: 10, time: Date(), title: "title", type: .story, url: nil)
    }
    
    static func makeCommentNode(id: Int, storyID: Int) -> CommentNode {
        let comment = Comment(by: "someone", id: id, kids: nil, parent: storyID, text: "123", time: Date(), type: .comment, deleted: nil, dead: nil)
        return CommentNode(comment: comment, depth: 0)
    }
}
