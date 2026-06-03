//
//  StoryStorageProtocol.swift
//  HackerReader
//
//  Created by mai on 5/29/26.
//

protocol StoryStorageProtocol {
    func fetchCached() async -> [Story]
    func fetchCached(id: Int) async -> Story?
    func save(_ stories: [Story]) async
}
