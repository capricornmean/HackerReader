//
//  HackerReaderApp.swift
//  HackerReader
//
//  Created by mai on 5/23/26.
//

import SwiftUI
import SwiftData

@main
struct HackerReaderApp: App {
    let container: ModelContainer
    let storyStorage: SwiftDataStoryStore
    let commentStorage: SwiftDataCommentStore
    
    var body: some Scene {
        WindowGroup {
            StoryListView(service: HackerNewsService(), storyStorage: storyStorage, commentStorage: commentStorage)
        }
        .modelContainer(container)
    }
    
    init() {
        guard let baseURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.mai.HackerReader") else {
            fatalError("Entitlement isn't applied")
        }
        let fileURL = baseURL.appending(path: "HackerReader.sqlite")
        let config = ModelConfiguration(url: fileURL)
        container = try! ModelContainer(for: StoredStory.self, StoredComment.self, configurations: config)
        storyStorage = SwiftDataStoryStore(context: container.mainContext)
        commentStorage = SwiftDataCommentStore(context: container.mainContext)
    }
}
