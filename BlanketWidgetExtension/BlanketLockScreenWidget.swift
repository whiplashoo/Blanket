import WidgetKit
import SwiftUI

struct BlanketEntry: TimelineEntry {
    let date: Date
}

struct BlanketProvider: TimelineProvider {
    func placeholder(in context: Context) -> BlanketEntry {
        BlanketEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (BlanketEntry) -> Void) {
        completion(BlanketEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BlanketEntry>) -> Void) {
        let entry = BlanketEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct BlanketLockScreenWidgetView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.black.opacity(0.25))
            Image(systemName: "moon.fill")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
        }
        .widgetURL(URL(string: "blanket://toggle"))
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

struct BlanketLockScreenWidget: Widget {
    let kind: String = "BlanketLockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BlanketProvider()) { _ in
            BlanketLockScreenWidgetView()
        }
        .configurationDisplayName("Blanket")
        .description("Quick access to Blanket from Lock Screen.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

#Preview(as: .accessoryCircular) {
    BlanketLockScreenWidget()
} timeline: {
    BlanketEntry(date: .now)
}
