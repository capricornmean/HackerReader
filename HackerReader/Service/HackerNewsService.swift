//
//  HackerNewsService.swift
//  HackerReader
//
//  Created by mai on 5/24/26.
//

import Foundation

enum FetchError: Error {
    case invalidURL
    case invalidResponse
    case responseError(Int)
}

struct HackerNewsService {
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    private func fetchHelper<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { throw FetchError.invalidResponse }
        guard (200..<300).contains(statusCode) else { throw FetchError.responseError(statusCode) }
        return try Self.decoder.decode(T.self, from: data)
    }
}

extension HackerNewsService: StoryFetchingProtocol {
    func fetchTopStoryIDs() async throws -> [Int] {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json") else { throw FetchError.invalidURL }
        return try await fetchHelper(url)
    }
    
    func fetchStories(ids: [Int]) async -> [Story] {
        await withTaskGroup(of: (Int, Story?).self) { group in
            for (index, id) in ids.enumerated() {
                group.addTask {
                    do {
                        let story = try await fetchStory(id: id)
                        return (index, story)
                    } catch {
                        print(error)
                        return (index, nil)
                    }
                }
            }
            
            var stories: Array<Story?> = .init(repeating: nil, count: ids.count)
            for await (index, story) in group {
                stories[index] = story
            }
            return stories.compactMap{ $0 }
        }
    }

    // MARK: - private
    private func fetchStory(id: Int) async throws -> Story {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json") else { throw FetchError.invalidURL }
        return try await fetchHelper(url)
    }
}

extension HackerNewsService: CommentFetchingProtocol {
    func fetchCommentTree(rootIDs: [Int]) async -> [CommentNode] {
        <#code#>
    }
}
