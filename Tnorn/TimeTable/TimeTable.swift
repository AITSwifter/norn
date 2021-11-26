//
//  TimeTable.swift
//  TimeTable
//
//  Created by nissy on 2021/10/19.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
    var moc = PersistenceController.shared.managedObjectContext
    
    init(context : NSManagedObjectContext) {
        self.moc = context
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        var timetable:[Timetable]?
        let request = NSFetchRequest<Timetable>(entityName: "Timetable")
        
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do{
            let result = try moc.fetch(request)
            timetable = result
            
        }
        catch let error as NSError{
            print("Could not fetch.\(error.userInfo)")
        }
        return SimpleEntry(date: Date(), text: "",timetable: timetable!,configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var timetable:[Timetable]?
        let request = NSFetchRequest<Timetable>(entityName: "Timetable")
        
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do{
            let result = try moc.fetch(request)
            timetable = result
            
        }
        catch let error as NSError{
            print("Could not fetch.\(error.userInfo)")
        }
        let entry = SimpleEntry(date: Date(), text: "",timetable: timetable!,configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // 現在の日付から開始して、1時間間隔で60エントリで構成されるタイムラインを生成する
        let currentDate = Date()
        var textArray = [String]()
        
        var timetable:[Timetable]?
        let request = NSFetchRequest<Timetable>(entityName: "Timetable")
        
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do{
            let result = try moc.fetch(request)
            timetable = result
            
        }
        catch let error as NSError{
            print("Could not fetch.\(error.userInfo)")
        }
        
        //        while true{
        for var i in 0..<61 {
            if i == 60{
                i = 0
            }
            textArray.append("更新回数: \(i)")
        }
        for minOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minOffset, to: currentDate)!
            let entryText = textArray[minOffset]
            let entry = SimpleEntry(date: entryDate, text: entryText,timetable: timetable!, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        //        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    let timetable: [Timetable]
    let configuration: ConfigurationIntent
}


// 下記でウィジェットの表示内容を設定

struct ViewTimeEntryView : View {
    //    @State var name: String
    var entry: Provider.Entry
    //    ここに表示するテキスト等を変更
    var body: some View {
        VStack {
            //            Text(name)
            VStack {
                Text(entry.date, style: .time)
            }
            .padding()
            Text(entry.timetable.first?.name ?? "None")
                .foregroundColor(.black)
            
        }
        //アプリ側ではonOpenURLを通じてURLをハンドリングし、Widgetをタップすれば特定の画面へ遷移するアクションを実現
        //        .widgetURL(URL(string: "widgetdemo://go2secondview"))
        .padding()
    }
    
}

@main
struct ViewTime: Widget {
    //    @Binding var name: String
    let kind: String = "ViewTime"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(context: PersistenceController.shared.managedObjectContext)) { entry in ViewTimeEntryView(entry: entry)                .environment(\.managedObjectContext, PersistenceController.shared.managedObjectContext)//

        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

//struct ViewTime_Previews: PreviewProvider {
//    //    @Binding var name: String
//    static var previews: some View {
//        ViewTimeEntryView(entry: SimpleEntry(date: Date(), text: "",timetable: timetable, configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//    }
//}
