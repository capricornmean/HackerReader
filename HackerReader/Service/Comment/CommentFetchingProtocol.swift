//
//  CommentFetchingProtocol.swift
//  HackerReader
//
//  Created by mai on 5/27/26.
//

protocol CommentFetchingProtocol {
    func fetchCommentTree(rootIDs: [Int]) async -> [CommentNode]
}
