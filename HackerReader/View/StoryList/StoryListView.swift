//
//  StoryListView.swift
//  HackerReader
//
//  Created by mai on 5/23/26.
//

import SwiftUI

struct StoryListView: View {
    @State private var storyVM = StoryViewModel(service: HackerNewsService())
    
    var body: some View {
        NavigationStack {
            if let error = storyVM.error, storyVM.stories.isEmpty {
                ErrorRow(error: error) {
                    await storyVM.retryInitial()
                }
            } else {
                List {
                    ForEach(storyVM.stories) { story in
                        NavigationLink(value: story) {
                            StoryRow(story: story)
                                .onAppear {
                                    if storyVM.stories.count >= 5,
                                       story.id == storyVM.stories[storyVM.stories.count - 5].id {
                                        Task { await storyVM.loadMore() }
                                    }
                                }
                        }
                    }
                    if storyVM.isLoading {
                        ProgressView()
                    }
                    if let error = storyVM.error {
                        ErrorRow(error: error) {
                            await storyVM.retryMore()
                        }
                    }
                }
                .navigationDestination(for: Story.self) { story in
                    StoryDetailView(story: story)
                }
            }
        }
        .task {
            await storyVM.loadInitial()
        }
    }
}

#Preview {
    StoryListView()
}
