//
//  SwiftDataStoryStoreTests.swift
//  HackerReaderTests
//
//  Created by mai on 6/3/26.
//

import Testing
import SwiftData
@testable import HackerReader

@MainActor struct SwiftDataStoryStoreTests {
    @Test func pruneRemoveStaleStoriesNotInNewList() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: StoredStory.self, StoredComment.self, configurations: config)
        let store = SwiftDataStoryStore(context: container.mainContext)
        let initialStories = [GeneralHelpers.makeStory(id: 1), GeneralHelpers.makeStory(id: 2), GeneralHelpers.makeStory(id: 3), GeneralHelpers.makeStory(id: 4), GeneralHelpers.makeStory(id: 5)]
        await store.save(initialStories)
        
        let newStories = [GeneralHelpers.makeStory(id: 3), GeneralHelpers.makeStory(id: 4)]
        await store.save(newStories)
        
        let cached = await store.fetchCached()
        #expect(cached.count == 2)
        #expect(Set(cached.map(\.id)) == Set([3, 4]))
    }
    
    @Test func upsertStory() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: StoredStory.self, StoredComment.self, configurations: config)
        let store = SwiftDataStoryStore(context: container.mainContext)
        
        let story = GeneralHelpers.makeStory(id: 1)
        await store.save([story])
        let newStory = GeneralHelpers.makeStory(id: 100)
        await store.save([newStory])
        let cached = await store.fetchCached().first
        #expect(cached?.id == 100)
    }
    
    @Test func rankStatibility() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: StoredStory.self, StoredComment.self, configurations: config)
        let store = SwiftDataStoryStore(context: container.mainContext)
        
        let initialStories = [GeneralHelpers.makeStory(id: 1), GeneralHelpers.makeStory(id: 2), GeneralHelpers.makeStory(id: 3), GeneralHelpers.makeStory(id: 4), GeneralHelpers.makeStory(id: 5)]
        await store.save(initialStories)
        let cached = await store.fetchCached()
        #expect(cached == initialStories)
    }
    
    @Test func commentStoreStoryIsolation() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: StoredStory.self, StoredComment.self, configurations: config)
        let storyStore = SwiftDataStoryStore(context: container.mainContext)
        let commentStore = SwiftDataCommentStore(context: container.mainContext)
        
        await storyStore.save([GeneralHelpers.makeStory(id: 1), GeneralHelpers.makeStory(id: 2)])
        let commentsA = [GeneralHelpers.makeCommentNode(id: 1, storyID: 1), GeneralHelpers.makeCommentNode(id: 2, storyID: 1), GeneralHelpers.makeCommentNode(id: 3, storyID: 1)]
        let commentsB = [GeneralHelpers.makeCommentNode(id: 100, storyID: 2), GeneralHelpers.makeCommentNode(id: 200, storyID: 2)]
        await commentStore.save(commentsA, forStory: 1)
        await commentStore.save(commentsB, forStory: 2)
        let cached = await commentStore.fetchCached(forStory: 1)
        #expect(Set(cached.map(\.id)) == Set(commentsA.map(\.id)))
    }
    
    @Test func storyNotInCache() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: StoredStory.self, StoredComment.self, configurations: config)
        let commentStore = SwiftDataCommentStore(context: container.mainContext)

        let comments = [GeneralHelpers.makeCommentNode(id: 1, storyID: 1), GeneralHelpers.makeCommentNode(id: 2, storyID: 1), GeneralHelpers.makeCommentNode(id: 3, storyID: 1)]
        await commentStore.save(comments, forStory: 1)
        #expect(try container.mainContext.fetchCount(FetchDescriptor<StoredComment>()) == 0)
        #expect(try container.mainContext.fetchCount(FetchDescriptor<StoredStory>()) == 0)
    }
}
