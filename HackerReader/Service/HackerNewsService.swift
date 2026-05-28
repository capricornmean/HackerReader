//
//  HackerNewsService.swift
//  HackerReader
//
//  Created by mai on 5/24/26.
//

import Foundation

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

    private func fetchStory(id: Int) async throws -> Story {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json") else { throw FetchError.invalidURL }
        return try await fetchHelper(url)
    }
}

extension HackerNewsService: CommentFetchingProtocol {
    func fetchCommentTree(rootIDs: [Int]) async -> [CommentNode] {
        await withTaskGroup(of: (Int, [CommentNode]).self) { group in
            for (index, rootID) in rootIDs.enumerated() {
                group.addTask {
                    (index, await fetchSubtree(id: rootID, depth: 0))
                }
            }
            var result: [[CommentNode]] = .init(repeating: [], count: rootIDs.count)
            for await (index, subtree) in group {
                result[index] = subtree
            }
            return result.flatMap{ $0 }
        }
    }
    
    private func fetchSubtree(id: Int, depth: Int) async -> [CommentNode] {
        guard let comment = try? await fetchComment(id: id) else { return [] }
        let node = CommentNode(comment: comment, depth: depth)
        guard let kids = comment.kids, !kids.isEmpty else { return [node] }
        return await withTaskGroup(of: (Int, [CommentNode]).self) { group in
            for (index, kid) in kids.enumerated() {
                group.addTask {
                    (index, await fetchSubtree(id: kid, depth: depth + 1))
                }
            }
            
            var children: [[CommentNode]] = .init(repeating: [], count: kids.count)
            for await (index, subtree) in group {
                children[index] = subtree
            }
            return [node] + children.flatMap{ $0 }
        }
    }

    private func fetchComment(id: Int) async throws -> Comment {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json") else { throw FetchError.invalidURL }
        return try await fetchHelper(url)
    }
}
