//
//  ContentView.swift
//  HackerReader
//
//  Created by mai on 5/23/26.
//

import SwiftUI

struct StoryRow: View {
    let story: Story

    var body: some View {
        VStack(alignment: .leading) {
            Text(story.title)
                .font(.headline)
            HStack {
                Text(story.by)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(story.score)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(story.descendants ?? 0)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct ErrorRow: View {
    var error: Error
    var retry: () async -> Void
    
    var body: some View {
        VStack {
            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.secondary)
            Button("Retry") {
                Task { await retry() }
            }
        }
    }
}

struct StoryDetailView: View {
    var story: Story
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(story.title)
                .font(.title2)
                .navigationTitle("Story")
            HStack {
                Text(story.by)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(story.score)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if let stringURL = story.url, let url = URL(string: stringURL) {
                Link("Read article", destination: url)
            }
            Spacer()
        }
    }
}

struct ContentView: View {
    @State private var viewModel = StoryListViewModel(service: HackerNewsService())
    
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
