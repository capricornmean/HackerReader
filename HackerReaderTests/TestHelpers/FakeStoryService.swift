//
//  FakeStoryService.swift
//  HackerReader
//
//  Created by mai on 6/4/26.
//

class FakeStoryService: StoryFetchingProtocol {
    var cannedTopIDs: [Int] = []
    var cannedStories: [Story] = []
    var onFetchStories: (() -> Void)?
    
    func fetchTopStoryIDs() async throws -> [Int] {
        return cannedTopIDs
    }
    
    func fetchStories(ids: [Int]) async -> [Story] {
        onFetchStories?()
        return cannedStories
    }
}
