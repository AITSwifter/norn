//
//  ContentPageView.swift
//  Tnorn
//
//  Created by nissy on 2021/11/09.
//

import SwiftUI
//import TimeTableExtension

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
                    }
                    .contentShape(Rectangle())
                    .onTapGesture{
                        self.select = item
                        

                    }
                    .sheet(item: self.$select, content: { select in
                        TableDetailView(Ttime: select.orditable! ,name: select.name!,direct: select.direction!)
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
                            try? Context.save()
                        }
                        .sheet(item: self.$select, content: { select in
                            PresetDetailView(Tdata: select.middname! ,Ntime: select.needtime! ,name:select.name! ,start: select.start!)
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

//時刻表プレビュー
struct TableDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var context
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Timetable.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Timetable>
    
    
    
    @State private var editselect = false
    
    @State var Ttime:[[Int]]
    @State var name:String
    @State var direct:String
    
    @State private var direction = ""
    @State private var ordinaly = true
    @State private var holiday = false
    
    @State private var showtimepicker = false
    @State private var keepTtime = 0
    @State private var keeptime = 0
    
    @State private var showingAlert = false
    @State var isdelete = false
    
    var textisVoid: Bool{
        return !name.isEmpty && !direction.isEmpty
    }
    
    var checkisVoid: Bool{
        return !ordinaly && !holiday
    }
    
    var checkiscount: Bool{
        var count = 0
        for times in Ttime{
            count += times.count
        }
        return count == 0
    }
    
    var getnum: Int{
        var rtn = 0
        for num in Ttime[keepTtime]{
            if num == rtn {
                rtn = num+1
            }else{
                break
            }
        }
        return rtn
    }
    
    var body: some View {
        HStack{
            Text(name)
            Text(direct)
            Button("編集"){
                self.editselect = true
            }
            /*
             .alert(isPresented: $editselect){
             Alert(title: Text("編集モード"),message: Text("編集ができるようになりました。"))
             }
             */
        }
        if editselect {
            //編集スペース
            Text("編集中")
            ZStack{
                Color.white
                    .opacity(0.4)
                //画面いっぱいに要素を展開
                    .edgesIgnoringSafeArea(.all)
                //キーボード以外のタップを検知したらキーボードを閉じる
                    .onTapGesture {
                        showtimepicker = false
                        UIApplication.shared.closeKeyboard()
                    }
                
                VStack{
                    HStack{
                        
                        InputStation(name: $name, direction: $direct)                }
                    
                    HStack{
                        Toggle("平日",isOn: $ordinaly)
                            .toggleStyle(MyCheckboxToggleStyle())
                            .padding()
                        Toggle("土日祝",isOn: $holiday)
                            .toggleStyle(MyCheckboxToggleStyle())
                            .padding()
                    }
                    
                    List{
                        ForEach(5..<25){ hour in
                            HStack{
                                Text("\(hour)")
                                    .frame(width: 30)
                                Divider()
                                ScrollView(.horizontal, showsIndicators: true){
                                    HStack{
                                        ForEach(Ttime[hour-5], id: \.self) { time in
                                            timeview(Ttime: $Ttime[hour-5],showpicker: $showtimepicker,index: hour-5,keepTtime: $keepTtime,keeptime: $keeptime,timenum: time)
                                        }
                                    }
                                }
                                Divider()
                                Button("+"){
                                    keepTtime = hour-5
                                    if Ttime[keepTtime].count < 60{
                                        Ttime[keepTtime].append(self.getnum)
                                    }
                                    Ttime[keepTtime].sort()
                                }
                                .frame(width: 20, height: 20,alignment: .top)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2))
                            }
                        }
                    }
                    
                    Button(action: {
                        self.showingAlert = true
                    }){
                        Text("保存")
                    }
                    .disabled(textisVoid || checkisVoid || checkiscount)
                    .alert(isPresented: $showingAlert){
                        Alert(title: Text("保存"),
                              message: Text("\(name)駅\(direct)方面を保存していいですか？"),
                              primaryButton:
                                    .cancel(Text("CANCEL")),
                              secondaryButton: .default(Text("OK"),
                                                        action:{ /// 現在のViewを閉じる
                            for (index,item) in Ttime.enumerated() {
                                Ttime[index].sort()
                            }
                            
                            savetable(text: name,direction: direct, num: Ttime, ordinal: ordinaly, holiday: holiday)
                            
                            self.presentationMode.wrappedValue.dismiss()}))
                    }
                    .padding()
                    
                }
                if showtimepicker{
                    timepicker(showpicker: $showtimepicker, selectminute: $Ttime[keepTtime][keeptime],Ttime: $Ttime[keepTtime])
                        .background(Color.white)
                        .frame(width: 300, height: 300, alignment: .center)
                        .border(Color.black)
                }
            }
            
            
        } else {
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
    
    
    
    func savetable(text: String,direction: String, num: [[Int]], ordinal: Bool, holiday: Bool){
        
        /// 時刻表新規登録処理
        let newTtable = Timetable(context: self.context)
        newTtable.name = text
        newTtable.direction = direction
        if ordinal {
            newTtable.orditable = num
        }
        if holiday {
            newTtable.holitable = num
        }
        newTtable.timestamp = Date()
         
        try? context.save()
    }
    
    
    
    struct MyCheckboxToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            return HStack {
                configuration.label
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .onTapGesture { configuration.isOn.toggle() }
            }
        }
    }
    
    
}

//プリセットプレビュー
struct PresetDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var Tdata: [String]
    @State var Ntime: [Int]
    @State var name: String
    @State var start: String
    
    var body: some View {
        
        /*
         ZStack{
             Color.white
                 .opacity(0.4)
             //画面いっぱいに要素を展開
                 .edgesIgnoringSafeArea(.all)
             //キーボード以外のタップを検知したらキーボードを閉じる
                 .onTapGesture {
                     UIApplication.shared.closeKeyboard()
                 }
             VStack{
                 CustomTextField(variable: $name, text: "プリセット名")
                 
                 ScrollView{
                     VStack{
                         HStack{
                             //出発駅名の入力欄
                             InputStation(name: $start, direction: $sdirect)
                         }
                         ForEach(0..<middname.count-1,id: \.self) { index in
                             
                             VStack{
                                 
                                 HStack{
                                     
                                     Text("↓")
                                         .padding()
                                     Text("所要時間")
                                     NumberField(variable: $needtime[index], text: "分")
                                         .frame(width: 70)
                                     Text("分")
                                         .frame(alignment: .leading)
                                 }
                                 InputStation(name: $middname[index], direction: $midddir[index])
                             }
                             
                         }
                         HStack{
                             Text("↓")
                                 .padding()
                             Text("所要時間")
                             NumberField(variable: $needtime.last!, text: "分")
                                 .frame(width: 70)
                             Text("分")
                                 .frame(alignment: .leading)
                             
                         }
                         
                         
                         //到着駅名の入力欄
                         HStack{
                             InputStation(name: $middname.last!, direction: $midddir.last!)
                             
                         }
                         
                         
                         
                     }
                 }
                 .padding()
                 
                 HStack{
                     Button("途中駅追加",action: {
                         self.middname.insert("", at: 0)
                         self.midddir.insert("", at: 0)
                         self.needtime.insert(0, at: 0)
                     })
                         .padding()
                     Button("途中駅削除",action: {
                         self.middname.removeFirst()
                         self.midddir.removeFirst()
                         self.needtime.removeFirst()
                         
                     })
                         .padding()
                         .disabled(middname.count == 1)
                 }
                 Button("保存",action: {
                     self.showingAlert = true
                     Savepreset(name: name, start: start, sdirect: sdirect, middname: middname, midddir:  midddir)
                     
                 })
                     .disabled(!textisVoid)
                     .padding()
                     .alert(isPresented: $showingAlert) {
                         Alert(title: Text("保存"),
                               message: Text("\(name)を保存しました"),
                               dismissButton: .default(Text("了解"),
                                                       action: {self.presentationMode.wrappedValue.dismiss()}))                         }
             }
             
             
             
             
         }
         */
        VStack{
            Text(name)
            ScrollView{
                VStack{
                    HStack{
                        Text(start)
                            .font(.title)
                    }
                    ForEach(0..<Ntime.count){ index in
                        HStack{
                            Text("↓")
                            Text("所要時間")
                            Text(String(Ntime[index]))
                            Text("分")
                            
                        }
                        .padding()
                        Text(Tdata[index])
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


