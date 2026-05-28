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

    init(service: StoryFetchingProtocol) {
        self.service = service
    }
    
    func loadInitial() async {
        await fetchTopStoryIDs()
        await loadMore()
    }
    
    func loadMore() async {
        guard offset < storyIDs.count, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        let newStoryIDs = Array(storyIDs[offset..<min(offset + 20, storyIDs.count)])
        let newStories = await service.fetchStories(ids: newStoryIDs)
        stories.append(contentsOf: newStories)
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
