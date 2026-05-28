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
            let text = node.isValid() ? node.getText() : "[deleted]"
            Text(text)
                .font(.body)
            HStack {
                let text = node.isValid() ? node.comment.by ?? "" : "[deleted]"
                Text(text)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text(node.comment.time, format: .relative(presentation: .named))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.leading, CGFloat(node.depth) * 12)
    }
}
