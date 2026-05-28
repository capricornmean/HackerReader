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
            let bodyText = node.comment.isValid ? node.comment.textWithoutHTMLTag : "[deleted]"
            Text(bodyText)
                .font(.body)
            HStack {
                let authorName = node.comment.isValid ? node.comment.by ?? "" : "[deleted]"
                Text(authorName)
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
