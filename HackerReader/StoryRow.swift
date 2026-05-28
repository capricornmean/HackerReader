//
//  StoryRow.swift
//  HackerReader
//
//  Created by mai on 5/27/26.
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
