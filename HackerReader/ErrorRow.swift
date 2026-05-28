//
//  ErrorRow.swift
//  HackerReader
//
//  Created by mai on 5/27/26.
//

import SwiftUI

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
