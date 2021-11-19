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

    @State private var select: Timetable? = nil
    
    var body: some View{
        NavigationView{
            
            List{
                ForEach(items) { item in
                    HStack{
                        Text(item.name ?? "noname")
                        Spacer()
                        Text(item.direction ?? "nodirection")
                        Spacer()
                        Text(String(item.orditable![1][1]))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture{
                        self.select = item
                    }
                    .sheet(item: self.$select, content: { select in
                        DetailView(Ttime: [[1,2],[4,6]] ,name:select.name ?? "nodata",direct: select.direction ?? "nodata")
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
        HStack{
            Button("閉じる"){
                self.presentationMode.wrappedValue.dismiss()
            }
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
                            DetailView2(Tdata: select.middname! ,Ttime: select.needtime! ,name:select.name! ,start: select.start!)
                            
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
    @State var start: String
    
    var body: some View {
        
        VStack{
            Text(name)
            ScrollView{
                VStack{
                    HStack{
                        Text(name)
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
        HStack{
            Button("閉じる"){
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        

    }
}
