//
//  StoryDetailView.swift
//  HackerReader
//
//  Created by mai on 5/27/26.
//

import SwiftUI

struct StoryDetailView: View {
    var story: Story
    @State private var commentVM = CommentViewModel(service: HackerNewsService())
    
    var body: some View {
        List {
            Section("Story") {
                VStack {
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
                }
            }
            Section("Comments") {
                ForEach(commentVM.nodes) { node in
                    CommentRow(node: node)
                }
                if commentVM.isLoading {
                    ProgressView()
                }
            }
        }
        .task {
            await commentVM.load(rootIDs: story.kids ?? [])
        }
    }
}
