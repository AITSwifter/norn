//
//  AddTimeTable.swift
//  Tnorn
//
//  Created by nissy on 2021/10/20.
//

import SwiftUI

struct AddTimeTable: View {
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var direction = ""
    @State private var Ttime: [[Int]] = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    
    @State private var ordinaly = true
    @State private var holiday = false
    
    @State private var showtimepicker = false
    @State private var keepTtime = 0
    @State private var keeptime = 0
    
    @State private var showingAlert = false
    
    @State private var isdelete = false
    
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
                .disabled(!textisVoid || checkisVoid || checkiscount)
                .alert(isPresented: $showingAlert){
                    Alert(title: Text("保存"),
                          message: Text("\(name)を保存していいですか？"),
                          primaryButton:
                                .cancel(Text("CANCEL")),
                          secondaryButton: .default(Text("OK"),
                                                    action:{ /// 現在のViewを閉じる
                        for (index,item) in Ttime.enumerated() {
                            Ttime[index].sort()
                        }
                        savetable(text: name,direction: direction, num: Ttime, ordinal: ordinaly, holiday: holiday)
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
        .navigationBarTitle("時刻表入力画面",displayMode: .inline)
        
    }
    
    func savetable(text: String,direction: String, num: [[Int]], ordinal: Bool, holiday: Bool){
        /// 時刻表新規登録処理
        let newTtable = Timetable(context: context)
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

struct AddTimeTable_Previews: PreviewProvider {
    static var previews: some View {
        AddTimeTable()
    }
}
