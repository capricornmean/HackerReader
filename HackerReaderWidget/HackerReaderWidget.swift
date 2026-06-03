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
    static let simpleEntryDefault = SimpleEntry(date: Date(), story: Story(by: "-",
                                                                           descendants: nil,
                                                                           id: 0,
                                                                           kids: nil,
                                                                           score: 0,
                                                                           time: Date(),
                                                                           title: "Loading...",
                                                                           type: .story,
                                                                           url: nil))
    
    static let container: ModelContainer = {
        let config = ContainerConstruction.getModelConfiguration()
        return try! ModelContainer(for: StoredStory.self, StoredComment.self, configurations: config)
    }()
    
    func placeholder(in context: Context) -> SimpleEntry {
        Self.simpleEntryDefault
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(Self.simpleEntryDefault)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = fetchTopStoryEntry()
        let next = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    private func fetchTopStoryEntry() -> SimpleEntry {
        do {
            let modelContext = ModelContext(Self.container)
            var descriptor = FetchDescriptor<StoredStory>(sortBy: [SortDescriptor(\.rank, order: .forward)])
            descriptor.fetchLimit = 1
            let top = try modelContext.fetch(descriptor).first
            return SimpleEntry(date: Date(), story: top?.asStory)
        } catch {
            print(error)
            return Self.simpleEntryDefault
        }
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
                    .font(.headline)
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
            .widgetURL(URL(string: "hackerreader://story/\(story.id)"))
        } else {
            Text("Open HackerReader")
        }
    }
}

struct HackerReaderWidget: Widget {
    let kind: String = "HackerReaderWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HackerReaderWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
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
