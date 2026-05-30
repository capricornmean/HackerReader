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
        let descriptor = FetchDescriptor<StoredStory>(sortBy: [SortDescriptor(\.time, order: .reverse)])
        do {
            return try context.fetch(descriptor).map(\.asStory)
        } catch {
            print(error)
            return []
        }
    }
    
    func save(_ stories: [Story]) async {
        do {
            for story in stories {
                let storyID = story.id
                var descriptor = FetchDescriptor<StoredStory>(predicate: #Predicate{ $0.id == storyID })
                descriptor.fetchLimit = 1
                let existing = try context.fetch(descriptor).first
                if let existing {
                    existing.by = story.by
                    existing.descendants = story.descendants
                    existing.kids = story.kids
                    existing.score = story.score
                    existing.time = story.time
                    existing.title = story.title
                    existing.type = story.type
                    existing.url = story.url
                } else {
                    context.insert(StoredStory(from: story))
                }
            }
            try context.save()
        } catch {
            print(error)
        }
    }
}
