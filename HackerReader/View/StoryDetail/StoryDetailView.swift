//
//  StoryDetailView.swift
//  HackerReader
//
//  Created by mai on 5/27/26.
//

import SwiftUI

struct StoryDetailView: View {
    var story: Story
    private var rootIDs: [Int]
    @State private var commentVM: CommentViewModel
    
    var body: some View {
        List {
            Section("Story") {
                VStack(alignment: .leading) {
                    Text(story.title)
                        .font(.title2)
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
            await commentVM.load(rootIDs: rootIDs)
        }
        .navigationTitle("Story")
    }
    
    init(story: Story, service: CommentFetchingProtocol, storage: CommentStorageProtocol) {
        self.story = story
        self.rootIDs = story.kids ?? []
        _commentVM = State(wrappedValue: CommentViewModel(service: service, rootIDs: rootIDs, storyID: story.id, storage: storage))
    }
}
