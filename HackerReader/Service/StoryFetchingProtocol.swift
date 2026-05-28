//
//  StoryFetchingProtocol.swift
//  HackerReader
//
//  Created by mai on 5/25/26.
//

protocol StoryFetchingProtocol {
    func fetchCommentTree(rootIDs: [Int]) async -> [CommentNode]
}
