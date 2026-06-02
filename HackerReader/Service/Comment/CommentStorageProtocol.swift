//
//  CommentStorageProtocol.swift
//  HackerReader
//
//  Created by mai on 6/1/26.
//

protocol CommentStorageProtocol {
    func fetchCached(forStory storyID: Int) async -> [CommentNode]
    func save(_ nodes: [CommentNode], forStory storyID: Int) async
}
