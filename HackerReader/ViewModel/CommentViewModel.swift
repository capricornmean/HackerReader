//
//  CommentViewModel.swift
//  HackerReader
//
//  Created by mai on 5/27/26.
//

import Foundation

@MainActor @Observable
class CommentViewModel {
    private(set) var nodes: [CommentNode] = []
    private(set) var isLoading: Bool = false
    private var rootIDs: [Int]
    private var storyID: Int
    
    private let service: CommentFetchingProtocol
    private let storage: CommentStorageProtocol
    
    init(service: CommentFetchingProtocol, rootIDs: [Int], storyID: Int, storage: CommentStorageProtocol) {
        self.service = service
        self.rootIDs = rootIDs
        self.storyID = storyID
        self.storage = storage
    }
    
    func load(rootIDs: [Int]) async {
        let cached = await storage.fetchCached(forStory: storyID)
        if !cached.isEmpty { nodes = cached }
        guard !isLoading, !rootIDs.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        nodes = await service.fetchCommentTree(rootIDs: rootIDs)
        await storage.save(nodes, forStory: storyID)
    }
}
