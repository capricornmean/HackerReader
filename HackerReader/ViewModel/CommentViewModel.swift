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
    
    private let service: CommentFetchingProtocol
    
    init(service: CommentFetchingProtocol) {
        self.service = service
    }
    
    func load(rootIDs: [Int]) async {
        guard !isLoading else { return }
        guard !rootIDs.isEmpty else {
            nodes = []
            return
        }
        isLoading = true
        defer { isLoading = false }
        nodes = await service.fetchCommentTree(rootIDs: rootIDs)
    }
}
