//
//  StoryViewModel.swift
//  HackerReader
//
//  Created by mai on 5/24/26.
//

import Foundation

@MainActor @Observable
class StoryViewModel {
    private var storyIDs: [Int] = []
    private(set) var stories: [Story] = []
    private(set) var isLoading: Bool = false
    private(set) var error: Error?
    private var offset: Int = 0
    
    private let service: StoryFetchingProtocol
    private let storage: StoryStorageProtocol

    init(service: StoryFetchingProtocol, storage: StoryStorageProtocol) {
        self.service = service
        self.storage = storage
    }
    
    func loadInitial() async {
        let cached = await storage.fetchCached()
        if !cached.isEmpty { stories = cached }
        isLoading = true
        defer { isLoading = false }
        await fetchTopStoryIDs()
        let firstPageIDs = Array(storyIDs[0..<20])
        let freshFirstPage = await service.fetchStories(ids: firstPageIDs)
        stories = freshFirstPage
        offset = firstPageIDs.count
        await storage.save(stories)
    }
    
    func loadMore() async {
        guard offset < storyIDs.count, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        let newStoryIDs = Array(storyIDs[offset..<min(offset + 20, storyIDs.count)])
        let newStories = await service.fetchStories(ids: newStoryIDs)
        stories.append(contentsOf: newStories)
        await storage.save(stories)
        offset += newStoryIDs.count
    }
    
    func retryInitial() async {
        error = nil
        await loadInitial()
    }
    
    func retryMore() async {
        error = nil
        await loadMore()
    }
    
    func fetchCached(id: Int) async -> Story? {
        return await storage.fetchCached(id: id)
    }
    
    // MARK: - Private
    private func fetchTopStoryIDs() async {
        isLoading = true
        defer { isLoading = false }
        do {
            storyIDs = try await service.fetchTopStoryIDs()
        } catch {
            self.error = error
        }
    }
}
