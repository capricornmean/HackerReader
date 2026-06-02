//
//  HackerReaderWidget.swift
//  HackerReaderWidget
//
//  Created by mai on 6/1/26.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    let container: ModelContainer = {
        let config = ContainerConstruction.getModelConfiguration()
        return try! ModelContainer(for: StoredStory.self, StoredComment.self, configurations: config)
    }()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), story: Story(by: "-",
                                               descendants: nil,
                                               id: 0,
                                               kids: nil,
                                               score: 0,
                                               time: Date(),
                                               title: "Loading...",
                                               type: .story,
                                               url: nil))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), story: Story(by: "-",
                                                           descendants: nil,
                                                           id: 0,
                                                           kids: nil,
                                                           score: 0,
                                                           time: Date(),
                                                           title: "Loading...",
                                                           type: .story,
                                                           url: nil))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = fetchTopStoryEntry()
        let next = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    private func fetchTopStoryEntry() -> SimpleEntry {
        let modelContext = ModelContext(container)
        var descriptor = FetchDescriptor<StoredStory>(sortBy: [SortDescriptor(\.rank, order: .forward)])
        descriptor.fetchLimit = 1
        let top = try? modelContext.fetch(descriptor).first
        return SimpleEntry(date: Date(), story: top?.asStory)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let story: Story?
}

struct HackerReaderWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if let story = entry.story {
            VStack(alignment: .leading) {
                Text(story.title)
                    .font(.title)
                    .lineLimit(3)
                Spacer()
                HStack {
                    Text(story.by)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text("\(story.score)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        } else {
            Text("Loading...")
        }
    }
}

struct HackerReaderWidget: Widget {
    let kind: String = "HackerReaderWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, iOS 17.0, *) {
                HackerReaderWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HackerReaderWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Hacker News widget")
        .description("Show a top story from Hacker News in a widget.")
        .supportedFamilies([.systemSmall])
    }
}

//#Preview(as: .systemSmall) {
//    HackerReaderWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//}
