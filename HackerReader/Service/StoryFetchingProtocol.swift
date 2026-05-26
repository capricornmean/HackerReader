//
//  StoryFetchingProtocol.swift
//  HackerReader
//
//  Created by mai on 5/25/26.
//

protocol StoryFetchingProtocol {
    func fetchTopStoryIDs() async throws -> [Int]
    func fetchStories(ids: [Int]) async throws -> [Story]
}
