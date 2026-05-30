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
    
    var body: some Scene {
        WindowGroup {
            StoryListView()
        }
        .modelContainer(container)
    }
    
    init() {
        container = try! ModelContainer(for: StoredStory.self)
    }
}
