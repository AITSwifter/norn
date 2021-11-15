//
//  ContentPageView.swift
//  Tnorn
//
//  Created by nissy on 2021/11/09.
//

import SwiftUI

struct ContentPageView: View {
    
    @Binding var selection: TabType
    
    var body: some View{
        TabView(selection: $selection){
            TableTabView().tag(TabType.timetable)
            PresetTabView().tag(TabType.preset)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

//時刻表
extension Int: Identifiable {
    public var id: Int { self }
}

struct TableTabView: View {
    @Environment(\.managedObjectContext) private var Context
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Timetable.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Timetable>
    
    @State var Ttime1 = [[11,12],[11,12],[11,12],[11,12],[11,12],[5,11,12],[11,12],[11,12],[11,12],[12,13],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12]]
    @State var Ttime2 = [[1,2],[11,12],[11,12],[11,12],[11,12],[5,11,12],[11,12],[11,12],[11,12],[12,13],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12]]
    @State private var select: Timetable? = nil
    
    var body: some View{
        NavigationView{
            
            List{
                ForEach(items) { item in
                    HStack{
                        Text(item.name ?? "noname")
                        Spacer()
                        Text(item.direction ?? "nodirection")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture{
                        self.select = item
                    }
                    .sheet(item: self.$select, content: { select in
                        DetailView(Ttime: Ttime1,name:select.name ?? "nodata",direct: select.direction ?? "nodata")
                    })
                }.onDelete(perform: delettimetable)
                
                
            }
            
        }
    }
    private func delettimetable(at offsets: IndexSet){
        for index in offsets {
            let putitem = items[index]
            Context.delete(putitem)
        }
        try? Context.save
    }
}


//時刻表プレビュー
struct DetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var Ttime:[[Int]]
    @State var name:String
    @State var direct:String
    var body: some View {
        HStack{
            Text(name)
            Text(direct)
        }
        
        List{
            ForEach(5..<25) { hour in
                HStack{
                    Text("\(hour)")
                        .frame(width: 30)
                    Divider()
                    ScrollView(.horizontal, showsIndicators: true){
                        HStack{
                            ForEach(Ttime[hour-5], id: \.self) { time in
                                Text(String(time))
                                //}.onDelete { offsets in
                                //  self.Ttime.remove(atOffsets: offsets)
                            }
                        }
                    }
                }
            }
        }
        Button("閉じる"){
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}


//プリセット

extension String: Identifiable {
    public var id: String { self }
}

struct PresetTabView: View {
    @Environment(\.managedObjectContext) private var Context
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Timetable.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Preset>
    
    @State private var select: Preset? = nil

//    @State var datas = ["通学","通勤","帰宅"]
//    @State var Tdata1 = ["八草","新豊田","岡崎"]//[出発,中間,到着]
    @State var Ttime1 = [10,20]
//    @State var Tdata2 = ["岡崎","新豊田","八草"]//[出発,時間,中間,到着]
    @State var Ttime2 = [30,20]
    
    var body: some View{
        NavigationView{
            ZStack{
                List{
                    ForEach(items) { item in
                        HStack{
                            Text(item.name ?? "nodata")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture{
                            self.select = item
                            
                        }
                        
                        .sheet(item: self.$select, content: { select in
                            DetailView2(Tdata: [select.start!,"長久手",select.end!],Ttime: Ttime1,name:select.name ?? "nodata")
                            
                        })
                    }.onDelete(perform: deletepreset)
                }
                
            }
            
        }
    }
    private func deletepreset(at offsets: IndexSet){
        for index in offsets {
            let putitem = items[index]
            Context.delete(putitem)
        }
        try? Context.save
    }
}


//プリセットプレビュー
struct DetailView2: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var Tdata: [String]
    @State var Ttime: [Int]
    @State var name: String
    
    var body: some View {
        
        VStack{
            Text(name)
            ScrollView{
                VStack{
                    HStack{
                        Text(Tdata[0])
                            .font(.title)
                    }
                    ForEach(0..<Ttime.count){ index in
                        HStack{
                            Text("↓")
                            Text("所要時間")
                            Text(String(Ttime[index]))
                            Text("分")
                            
                        }
                        .padding()
                        Text(Tdata[index+1])
                            .font(.title)

                    }
                }
            }
            .padding()
        }
        
        Button("閉じる"){
            self.presentationMode.wrappedValue.dismiss()
        }

    }
}
