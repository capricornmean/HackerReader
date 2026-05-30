//
//  SwiftDataStoryStore.swift
//  HackerReader
//
//  Created by mai on 5/29/26.
//

import Foundation
import SwiftData

@MainActor final class SwiftDataStoryStore: StoryStorageProtocol {
    func fetchCached() async -> [Story] {
        let descriptor = FetchDescriptor<StoredStory>()
    }
    
    func save(_ stories: [Story]) async {
        for story in stories {
            let storyID = story.id
            let descriptor = FetchDescriptor<StoredStory>(predicate: #Predicate{ $0.id == storyID })
            try context.fetch(descriptor)
        }
        try context.save()
    }
    
    
}
