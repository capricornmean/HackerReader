//
//  CommentRow.swift
//  HackerReader
//
//  Created by mai on 5/27/26.
//

import SwiftUI

struct CommentRow: View {
    let node: CommentNode

    var body: some View {
        VStack(alignment: .leading) {
            Text(node.comment.displayText)
                .font(.body)
            HStack {
                Text(node.comment.displayAuthor)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text(node.comment.time, format: .relative(presentation: .named))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.leading, CGFloat(min(node.depth, 8)) * 12)
    }
}
