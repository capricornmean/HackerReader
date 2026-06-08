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
    var pauseFetchStories: Bool = false
    var fetchStoriesCalledCount: Int = 0
    private var continuation: CheckedContinuation<Void, Never>?
    
    func fetchTopStoryIDs() async throws -> [Int] {
        return cannedTopIDs
    }
    
    func fetchStories(ids: [Int]) async -> [Story] {
        fetchStoriesCalledCount += 1
        onFetchStories?()
        if pauseFetchStories {
            await withCheckedContinuation { continuation = $0 }
        }
        return cannedStories
    }
    
    func releasePausedFetch() {
        continuation?.resume()
        continuation = nil
    }
}
