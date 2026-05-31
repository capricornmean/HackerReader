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
    
    var body: some Scene {
        WindowGroup {
            StoryListView(service: HackerNewsService(), storage: storyStorage)
        }
        .modelContainer(container)
    }
    
    init() {
        container = try! ModelContainer(for: StoredStory.self)
        storyStorage = SwiftDataStoryStore(context: container.mainContext)
    }
}
