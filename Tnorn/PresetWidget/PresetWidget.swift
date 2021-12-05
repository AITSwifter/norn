//
//  PresetWidget.swift
//  PresetWidget
//
//  Created by nissy on 2021/11/30.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), set: attset,position: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),set: attset,position: 1)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for minOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minOffset, to: currentDate)!
            var entryset = attset
            if minOffset > 30{
                entryset = retset
            }
            
            let entry = SimpleEntry(date: entryDate,set: entryset, position: minOffset%3)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let set: Preset
    let position: Int
    
}

struct Preset{
    let name: String
    let stations: [Station]
    let needtime: [Int]
}

struct Station{
    let name: String
    let dirct: String
    let timetable: [[Int]]
}

struct PresetWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    let maxcount = 3
    var h: Int{
        let components = Calendar.current.dateComponents(in: TimeZone.current, from: entry.date)
        if components.hour! > 5{
            return components.hour!
        } else if components.hour! > 0 {
            return 5
        }else{
            return 24
        }
    }
    var m: Int{
        let components = Calendar.current.dateComponents(in: TimeZone.current, from: entry.date)
        if h != 5{
            return components.minute!
        } else {
            return 0
        }

    }
    var neartable: [[Int]]{
        var count = 0
        var rtn = [[0,0],[0,0],[0,0]]
        for hin in h-5 ..< 20{
            for item in ftable[hin]{
                if m < item || h-5 < hin{
                    rtn[count][0] = hin
                    rtn[count][1] = item
                    count += 1
                    if count == maxcount{
                        break
                    }
                }

            }
            if count == maxcount{
                break
            }
        }
        return rtn
    }

    var neartable2: [[Int]]{
        var count = 0
        var rtn = [[0,0],[0,0],[0,0]]
        if entry.position+1 != entry.set.stations.count{
            for hin in h-5 ..< 20{
                for item in stable[hin]{
                    if m + entry.set.needtime[entry.position] >= item || h-5 < hin{
                        rtn[count][0] = hin
                        rtn[count][1] = item
                        count += 1
                        if count == maxcount{
                            break
                        }
                    }

                }
                if count == maxcount{
                    break
                }
            }
        }else{
            rtn = neartable
            for index in 0..<rtn.count{
                rtn[index][1] += entry.set.needtime[entry.position]
                if rtn[index][1] >= 60{
                    rtn[index][1] = rtn[index][1] % 60
                    rtn[index][0] += 1
                }
            }
        }
        return rtn
    }


    var ftable: [[Int]]{
        return entry.set.stations[entry.position].timetable
    }

    var stable: [[Int]]{
        if entry.position == 2{
            return [[0]]
        }
        return entry.set.stations[entry.position+1].timetable
    }

    var body: some View {
        switch family {
        case .systemSmall:
            SmallView(table: neartable, set: entry.set,position: entry.position)
        case .systemMedium:
            MediumView(neartable: [neartable,neartable2],needtime: entry.set.needtime, set: entry.set,position: entry.position)
        default:
            fatalError()
        }
    }
}

struct SmallView: View{
    var table: [[Int]]
    var set: Preset
    var position: Int
    var body: some View{
        VStack{
            HStack{
                Text(set.name)
                    .font(.caption)
                Text(set.stations[position].name+"発")
                    .font(.caption)

            }
            stableView(table: table)
        }
    }
}

struct MediumView: View{
    var neartable: [[[Int]]]
    var needtime: [Int]
    var set: Preset
    var position: Int
    
    
    var names: [String]{
        var rtn : [String] = []
        for item in set.stations{
            rtn.append(item.name)
        }
        rtn.append("到着時間")
        return rtn
    }
    var body: some View{
        VStack{
            Text(set.name)
                .font(.caption)
            HStack{
                HStack{
                    ForEach(0 ..< neartable.count, id: \.self){ index in
                        VStack{
                            tableView(name: names[position+index], table: neartable[index])

                        }
                        VStack{
                            if names[position+index] != "到着時間"{
                                Text("→")
                                Text(String(needtime[position+index])+"分")
                            }
                        }
                        .padding()
                    }
                }
            }

        }
    }

}

struct stableView: View{
    var table: [[Int]]
    var body: some View{
        VStack{
            ForEach(table, id: \.self){ item in
                if item[0]+item[1] != 0{
                    if item[1] < 10{
                        Text(String(item[0]+5)+":0"+String(item[1]))
                            .font(.title2)
                    }else{
                        Text(String(item[0]+5)+":"+String(item[1]))
                            .font(.title2)
                    }

                } else{
                    Text("なし")
                        .font(.title2)

                }
            }
        }

    }
}


struct tableView: View{
    var name: String
    var table: [[Int]]
    var body: some View{
        Text(name+"発")
            .font(.caption)
        VStack{
            ForEach(table, id: \.self){ item in
                if item[0]+item[1] != 0{
                    if item[1] < 10{
                        Text(String(item[0]+5)+":0"+String(item[1]))
                            .font(.title2)
                    }else{
                        Text(String(item[0]+5)+":"+String(item[1]))
                            .font(.title2)
                    }

                } else{
                    Text("なし")
                        .font(.title2)

                }
            }
        }

    }
}

@main
struct PresetWidget: Widget {
    let kind: String = "PresetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PresetWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("通学路")
        .description("This is an example widget.")
    }
}

struct PresetWidget_Previews: PreviewProvider {
    static var previews: some View {
        PresetWidgetEntryView(entry: SimpleEntry(date: Date(),set: attset, position: 1))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
    
}
