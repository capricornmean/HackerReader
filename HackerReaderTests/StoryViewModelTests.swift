//
//  StoryViewModelTests.swift
//  HackerReader
//
//  Created by mai on 6/3/26.
//

import Testing

@MainActor struct StoryViewModelTests {
    @Test func loadInitalReplaceCacheWithFresh() async {
        let cached = [GeneralHelpers.makeStory(id: 1)]
        let fresh = [GeneralHelpers.makeStory(id: 2), GeneralHelpers.makeStory(id: 3)]
        let storage = FakeStoryStorage()
        storage.cannedCached = cached
        let service = FakeStoryService()
        service.cannedTopIDs = [2, 3]
        service.cannedStories = fresh
        let vm = StoryViewModel(service: service, storage: storage)

        var snapshotMidFlight: [Story] = []
        service.onFetchStories = {
            snapshotMidFlight = vm.stories
        }
        await vm.loadInitial()
        #expect(snapshotMidFlight.map(\.id) == [1])
        #expect(vm.stories.map(\.id) == [2, 3])
        #expect(storage.savedCalls.count == 1)
        #expect(storage.savedCalls.first?.map(\.id) == [2, 3])
    }
    
    @Test func loadMore() async {
        let storage = FakeStoryStorage()
        let service = FakeStoryService()
        service.cannedTopIDs = [1, 2, 3]
        service.cannedStories = [GeneralHelpers.makeStory(id: 1)]
        let vm = StoryViewModel(service: service, storage: storage)
        await vm.loadInitial()
        
//        service.cannedTopIDs = [1, 2, 3]
        service.cannedStories = [GeneralHelpers.makeStory(id: 1), GeneralHelpers.makeStory(id: 2), GeneralHelpers.makeStory(id: 3)]
        await vm.loadMore()
        #expect(storage.savedCalls.count == 2)
        #expect(storage.savedCalls.last?.map(\.id) == [2, 3])
    }
}
