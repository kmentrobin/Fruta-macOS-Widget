//
//  IntentWidgets.swift
//  Fruta
//
//  Created by Robin Kment on 2/6/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import WidgetKit
import Intents
import SwiftUI

struct FavoriteSmoothieWidget: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: "FavoriteSmoothie", intent: FavoriteSmoothieIntent.self, provider: Provider()) { entry in
            FavoriteSmoothieEntryView(entry: entry)
        }
        .configurationDisplayName("Favorite Smoothie")
        .description("Displays the favorite Smoothie!")
    }
}

extension FavoriteSmoothieWidget {
    struct Provider: IntentTimelineProvider {
        func getSnapshot(for configuration: FavoriteSmoothieIntent, in context: Context, completion: @escaping (FavoriteSmoothieWidget.Entry) -> Void) {
            let entry = Entry(date: Date(), smoothie: .berryBlue)
            completion(entry)
        }
        
        func getTimeline(for configuration: FavoriteSmoothieIntent, in context: Context, completion: @escaping (Timeline<FavoriteSmoothieWidget.Entry>) -> Void) {

            guard let smoothie = configuration.smoothie,
                  let id = smoothie.identifier,
                  let selectedSmoothie = Smoothie.all.first(where: { $0.id == id}) else {
                let entry = Entry(date: Date(), smoothie: .berryBlue)
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
                return
            }
            
            let entry = Entry(date: Date(), smoothie: selectedSmoothie)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
        
        
        typealias Intent = FavoriteSmoothieIntent
            
        typealias Entry = FavoriteSmoothieWidget.Entry
       
        func placeholder(in context: Context) -> Entry {
            Entry(date: Date(), smoothie: .berryBlue)
        }
    }
}

extension FavoriteSmoothieWidget {
    struct Entry: TimelineEntry {
        var date: Date
        var smoothie: Smoothie
    }
}

struct FavoriteSmoothieEntryView: View {
    var entry: FavoriteSmoothieWidget.Provider.Entry
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    var title: some View {
        Text(entry.smoothie.title)
            .font(widgetFamily == .systemSmall ? Font.body.bold() : Font.title3.bold())
            .lineLimit(1)
            .minimumScaleFactor(0.1)
    }
    
    var description: some View {
        Text(entry.smoothie.description)
            .font(.subheadline)
    }
    
    var calories: some View {
        Text("\(entry.smoothie.kilocalories) Calories")
            .foregroundColor(.secondary)
            .font(.subheadline)
    }
    
    var image: some View {
        Rectangle()
            .overlay(
                entry.smoothie.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .aspectRatio(1, contentMode: .fit)
            .clipShape(ContainerRelativeShape())
    }
    
    var body: some View {
        ZStack {
            if widgetFamily == .systemMedium {
                HStack(alignment: .top, spacing: 20) {
                    VStack(alignment: .leading) {
                        title
                        description
                        calories
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityElement(children: .combine)
                    
                    image
                }
                .padding()
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        title
                        if widgetFamily == .systemLarge {
                            description
                            calories
                        }
                    }
                    .accessibilityElement(children: .combine)
                    
                    image
                        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BubbleBackground())
    }
}

struct FavoriteSmoothieWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FavoriteSmoothieEntryView(entry: FavoriteSmoothieWidget.Entry(date: Date(), smoothie: .berryBlue))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            FavoriteSmoothieEntryView(entry: FavoriteSmoothieWidget.Entry(date: Date(), smoothie: .kiwiCutie))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            FavoriteSmoothieEntryView(entry: FavoriteSmoothieWidget.Entry(date: Date(), smoothie: .thatsBerryBananas))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
