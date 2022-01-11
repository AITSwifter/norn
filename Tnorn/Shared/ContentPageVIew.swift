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
    @State private var selectnum: Int? = nil
    @State var isedit = false
    
    @State var setname : String = "a"
    @State var setdirection : String = "s"
    @State var setordi : [[Int]] = [[0]]
    @State var setholi : [[Int]] = [[0]]
    @State var io = [[0]]
    
    var body: some View{
        NavigationView{
            
            List{
                ForEach(items, id: \.self) { item in
                    HStack{
                        Text(item.name ?? "noname")
                        Spacer()
                        Text(item.direction ?? "nodirection")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture{
                        self.select = item
                        selectnum = items.firstIndex(of: self.select!)
                        setname = select!.name!
                        setdirection = select!.direction!
                        setordi = select!.orditable ?? [[0]]
                        setholi = select!.holitable ?? [[0]]
                        
                        if setordi == [[0]] {
                            io = setholi
                        }else{
                            io = setordi
                        }
                    }
                    .sheet(item: self.$select,onDismiss: {
                        if isedit{
                            items[selectnum!].name = setname
                            items[selectnum!].direction = setdirection
                            items[selectnum!].orditable = setordi
                            items[selectnum!].holitable = setholi
                            try? Context.save
                        }
                        isedit = false
                    }, content: { select in
                        
                        TableDetailView(isedit: $isedit, Ttime: $io, name: $setname, direction: $setdirection, orditable: $setordi, holitable: $setholi)
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
struct TableDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var context
    
    
    @State private var editselect = false
    @Binding var isedit : Bool
    
    @Binding var Ttime:[[Int]]
    @Binding var name:String
    //@Binding var direct:String
    
    @Binding var direction:String
    @State var ordinal = true
    @State var holiday = false
    
    @State var showtimepicker = false
    @State var keepTtime = 0
    @State var keeptime = 0
    
    @State var showingAlert = false
    @State var isdelete = false
    
    @Binding var orditable: [[Int]]
    @Binding var holitable: [[Int]]
    
    var textisVoid: Bool{
        return !name.isEmpty && !direction.isEmpty
    }
    
    var checkisVoid: Bool{
        return !ordinal && !holiday
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
    
    var gettable: [[Int]]{
        if ordinal {
            return orditable
        }else{
            return holitable
        }
    }
    
    var body: some View {
        
        
        
        HStack{
            Text(name)
            Text(direction)
            Button("編集"){
                self.editselect = true
            }
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
                        
                        InputStation(name: $name, direction: $direction)                }
                    
                    HStack{
                        Toggle("平日",isOn: $ordinal)
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
                    HStack{
                        Button(action:{
                            self.editselect = false
                        }){
                            Text("戻る")
                        }
                        Button(action: {
                            self.showingAlert = true
                        }){
                            Text("保存")
                        }
                        .disabled(!textisVoid || checkisVoid || checkiscount)
                        .alert(isPresented: $showingAlert){
                            Alert(title: Text("保存"),
                                  message: Text("\(name)駅\(direction)方面を保存していいですか？"),
                                  primaryButton:
                                        .cancel(Text("CANCEL")),
                                  secondaryButton: .default(Text("OK"),
                                                            action:{ /// 現在のViewを閉じる
                                for (index,item) in Ttime.enumerated() {
                                    Ttime[index].sort()
                                }
                                
                                if ordinal {
                                    orditable = Ttime
                                    
                                }
                                if holiday {
                                    holitable = Ttime
                                }
                                isedit = true
                                self.presentationMode.wrappedValue.dismiss()}))
                        }
                        .padding()
                    }
                }
                if showtimepicker{
                    timepicker(showpicker: $showtimepicker, selectminute: $Ttime[keepTtime][keeptime],Ttime: $Ttime[keepTtime])
                        .background(Color.white)
                        .frame(width: 300, height: 300, alignment: .center)
                        .border(Color.black)
                }
            }
            
            
        } else {
            HStack{
                Button (action: {
                    Ttime = orditable
                }){
                    Text("平日")
                }
                .disabled(orditable.count == 1)
                Button(action: {
                    Ttime = holitable
                }){
                    Text("土日祝")
                }
                .disabled(holitable.count == 1)
                
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

//プリセット---------------------------------------------------------------------------------------------------------------------------------

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
    @State private var selectnum: Int? = nil
    @State var isedit = false
    
    /*
     @State var setTdata : [String]
     @State var setNtime : [Int]
     */
    @State  var setname = ""
    @State  var setstart = ""
    @State  var setsdirect = ""
    @State  var setmiddname: [String] = [""]
    @State  var setmidddir: [String] = [""]
    @State  var setneedtime: [Int] = [10]
    
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
                            selectnum = items.firstIndex(of: self.select!)
                            setname = select!.name!
                            setstart = select!.start!
                            setsdirect = select!.sdirect!
                            setmiddname = select!.middname ?? ["d"]
                            setmidddir = select!.midddir ?? ["a"]
                            setneedtime = select!.needtime ?? [1]
                            
                            
                        }
                        .sheet(item: self.$select,onDismiss: {
                            if isedit{
                                items[selectnum!].name = setname
                                items[selectnum!].start = setstart
                                items[selectnum!].sdirect = setsdirect
                                items[selectnum!].middname = setmiddname
                                items[selectnum!].midddir = setmidddir
                                items[selectnum!].needtime = setneedtime
                                try? Context.save
                            }
                            isedit = false
                        }, content: { select in
                            
                            PresetDetailView(isedit: $isedit, Tdata: select.middname ?? ["d"], Ntime: select.needtime ?? [0], name: $setname, start: $setstart, sdirect: $setsdirect, middname: $setmiddname, midddir: $setmidddir, needtime: $setneedtime)
                            
                            //PresetDetailView(isedit: $isedit, Tdata: $setTdata ,Ntime: $setNtime ,name: $setname ,start: $setstart)
                            //PresetDetailView(isedit: $isedit, name: $setname, start: $setstart, sdirect: $setsdirect, middname: $setmiddname, midddir: $setmidddir, needtime: $setneedtime)
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
struct PresetDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var context
    @State private var editselect = false
    @Binding var isedit : Bool
    
    @State var Tdata: [String]
    
    @State var Ntime: [Int]
    //@State var name: String
    //@State var start: String
    @Binding  var name : String
    @Binding  var start : String
    @Binding  var sdirect  : String
    @Binding  var middname: [String]
    @Binding  var midddir: [String]
    @Binding  var needtime: [Int]
    @State private var showingAlert = false
    
    var textisVoid: Bool{
        return !start.isEmpty && !name.isEmpty && !sdirect.isEmpty && checklistEnpty
    }
    
    var checklistEnpty: Bool{
        return middname.firstIndex(of: "") == nil && midddir.firstIndex(of: "") == nil
    }
    
    
    var body: some View {
        
        HStack{
            Text(name)
            Text(start)
            Button("編集"){
                self.editselect = true
            }
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
                        
                        
                    })
                        .disabled(!textisVoid)
                        .padding()
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("保存"),
                                  message: Text("\(name)を保存しました"),
                                  dismissButton: .default(Text("了解"),
                                                          action: {
                                isedit = true
                                self.presentationMode.wrappedValue.dismiss()}))                         }
                }
                
                
                
                
            }
        } else {
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
}




