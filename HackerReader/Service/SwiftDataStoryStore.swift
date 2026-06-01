//
//  SwiftDataStoryStore.swift
//  HackerReader
//
//  Created by mai on 5/29/26.
//

import Foundation
import SwiftData

@MainActor final class SwiftDataStoryStore: StoryStorageProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchCached() async -> [Story] {
        let descriptor = FetchDescriptor<StoredStory>(sortBy: [SortDescriptor(\.rank, order: .forward)])
        do {
            return try context.fetch(descriptor).map(\.asStory)
        } catch {
            print(error)
            return []
        }
    }
    
    func save(_ stories: [Story]) async {
        do {
            let newIDs = Set(stories.map(\.id))
            let staleDescriptor = FetchDescriptor<StoredStory>(predicate: #Predicate {!newIDs.contains($0.id)})
            let staleRows = try context.fetch(staleDescriptor)
            for row in staleRows {
                context.delete(row)
            }
            for (index, story) in stories.enumerated() {
                let storyID = story.id
                var existDescriptor = FetchDescriptor<StoredStory>(predicate: #Predicate{ $0.id == storyID })
                existDescriptor.fetchLimit = 1
                let existing = try context.fetch(existDescriptor).first
                if let existing {
                    existing.by = story.by
                    existing.descendants = story.descendants
                    existing.kids = story.kids
                    existing.score = story.score
                    existing.time = story.time
                    existing.title = story.title
                    existing.type = story.type
                    existing.url = story.url
                    existing.rank = index
                } else {
                    context.insert(StoredStory(from: story, rank: index))
                }
            }
            try context.save()
        } catch {
            print(error)
        }
    }
}
