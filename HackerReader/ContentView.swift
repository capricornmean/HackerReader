//
//  ContentView.swift
//  HackerReader
//
//  Created by mai on 5/23/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = StoryViewModel(service: HackerNewsService())
    
    var body: some View {
        NavigationStack {
            if let error = viewModel.error, viewModel.stories.isEmpty {
                ErrorRow(error: error) {
                    await viewModel.retryInitial()
                }
            } else {
                List {
                    ForEach(viewModel.stories) { story in
                        NavigationLink(value: story) {
                            StoryRow(story: story)
                                .onAppear {
                                    if viewModel.stories.count >= 5,
                                       story.id == viewModel.stories[viewModel.stories.count - 5].id {
                                        Task { await viewModel.loadMore() }
                                    }
                                }
                        }
                    }
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    if let error = viewModel.error {
                        ErrorRow(error: error) {
                            await viewModel.retryMore()
                        }
                    }
                }
                .navigationDestination(for: Story.self) { story in
                    StoryDetailView(story: story)
                }
            }
        }
        .task {
            await viewModel.loadInitial()
        }
    }
}

#Preview {
    ContentView()
}
