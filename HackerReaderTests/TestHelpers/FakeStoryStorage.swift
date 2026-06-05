//
//  FakeStoryStorage.swift
//  HackerReader
//
//  Created by mai on 6/3/26.
//

class FakeStoryStorage: StoryStorageProtocol {
    var cannedCached: [Story] = []
    var savedCalls: [[Story]] = []
    
    func fetchCached() async -> [Story] {
        return cannedCached
    }
    
    func fetchCached(id: Int) async -> Story? {
        return cannedCached.first(where: { $0.id == id })
    }
    
    func save(_ stories: [Story]) async {
        savedCalls.append(stories)
    }
}
