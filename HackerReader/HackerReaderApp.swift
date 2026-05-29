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
    let modelContainer: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            StoryListView()
        }
        .modelContainer(modelContainer)
    }
    
    init () {
        modelContainer = try! ModelContainer(for: StoredStory.self)
    }
}
