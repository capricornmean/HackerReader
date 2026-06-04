//
//  SwiftDataCommentStore.swift
//  HackerReader
//
//  Created by mai on 6/1/26.
//

import Foundation
import SwiftData

@MainActor final class SwiftDataCommentStore: CommentStorageProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchCached(forStory storyID: Int) async -> [CommentNode] {
        do {
            var storyDescriptor = FetchDescriptor<StoredStory>(predicate: #Predicate{ $0.id == storyID })
            storyDescriptor.fetchLimit = 1
            let storedStory = try context.fetch(storyDescriptor).first
            return storedStory?.comments.sorted { $0.rank < $1.rank }.map{ $0.asCommentNode } ?? []
        } catch {
            print(error)
            return []
        }
    }
    
    func save(_ nodes: [CommentNode], forStory storyID: Int) async {
        do {
            var storyDescriptor = FetchDescriptor<StoredStory>(predicate: #Predicate{ $0.id == storyID })
            storyDescriptor.fetchLimit = 1
            guard let storedStory = try context.fetch(storyDescriptor).first else {
                return
            }
            // prune stale cache
            let newIDs = Set(nodes.map(\.comment.id))
            let staleCommentDescriptor = FetchDescriptor<StoredComment>(predicate: #Predicate{ !newIDs.contains($0.id) && $0.parent == storyID })
            let staleRows = try context.fetch(staleCommentDescriptor)
            for row in staleRows {
                context.delete(row)
            }
            // add new cache
            for (index, node) in nodes.enumerated() {
                let commentID = node.id
                var commentDescriptor = FetchDescriptor<StoredComment>(predicate: #Predicate{ $0.id == commentID })
                commentDescriptor.fetchLimit = 1
                if let storedComment = try context.fetch(commentDescriptor).first {
                    storedComment.by = node.comment.by
                    storedComment.kids = node.comment.kids
                    storedComment.parent = node.comment.parent
                    storedComment.text = node.comment.text
                    storedComment.time = node.comment.time
                    storedComment.type = node.comment.type
                    storedComment.deleted = node.comment.deleted
                    storedComment.dead = node.comment.dead
                    storedComment.depth = node.depth
                    storedComment.rank = index
                    storedComment.story = storedStory
                } else {
                    context.insert(StoredComment(from: node.comment, depth: node.depth, rank: index, story: storedStory))
                }
            }
            try context.save()
        } catch {
            print(error)
        }
    }
    
}
