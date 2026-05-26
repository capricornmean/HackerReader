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

struct ContentView: View {
    @State private var viewModel = StoryListViewModel(service: HackerNewsService())
    
    var body: some View {
        NavigationStack {
            if let error = viewModel.error {
                Text(error.localizedDescription)
            } else {
                List {
                    ForEach(viewModel.stories) { story in
                        StoryRow(story: story)
                            .onAppear {
                                if story.id == viewModel.stories[max(0, viewModel.stories.count - 5)].id {
                                    Task { await viewModel.loadMore() }
                                }
                            }
                    }
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
            }
        }
        .task {
            await viewModel.loadInitial()
        }
    }
}

#Preview {
//    StoryRow(story: Story(by: "mai", descendants: 0, id: 111, kids: [], score: 100, time: Date(), title: "Hello Mai", type: .story, url: nil))
    ContentView()
}
