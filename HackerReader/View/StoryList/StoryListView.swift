//
//  StoryListView.swift
//  HackerReader
//
//  Created by mai on 5/23/26.
//

import SwiftUI
import SwiftData

struct StoryListView: View {
    @State private var storyVM: StoryViewModel
    private let service: StoryFetchingProtocol & CommentFetchingProtocol
    private let commentStorage: CommentStorageProtocol
    
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
                    StoryDetailView(story: story, service: service, storage: commentStorage)
                }
            }
        }
        .task {
            await storyVM.loadInitial()
        }
    }

    init(service: StoryFetchingProtocol & CommentFetchingProtocol, storyStorage: StoryStorageProtocol, commentStorage: CommentStorageProtocol) {
        _storyVM = State(wrappedValue: StoryViewModel(service: service, storage: storyStorage))
        self.service = service
        self.commentStorage = commentStorage
    }
}

//#Preview {
//    StoryListView(service: HackerNewsService(), storage: SwiftDataStoryStore(context: try! ModelContainer(for: StoredStory.self).mainContext))
//}
