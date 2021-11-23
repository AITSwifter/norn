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
    @State private var Ttimenum = 0
    
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
    
    var body: some View {
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
                            ScrollView(.horizontal, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/){
                                HStack{
                                    ForEach(Ttime[hour-5], id: \.self) { time in
                                        Text(String(time))
                                            .onLongPressGesture {
                                                isdelete = true
                                            }
                                            .alert(isPresented: $isdelete){
                                                Alert(title: Text("削除"), message: Text("この要素を削除しますか？"), primaryButton: .default(Text("取消")), secondaryButton: .destructive(Text("削除"),action: {
                                                    if Ttime[hour-5].firstIndex(of: time) != nil {
                                                        Ttime[hour-5].remove(at: Ttime[hour-5].firstIndex(of: time)!)
                                                    }
                                                }))
                                            }
                                    }
                                }
                            }
                            Divider()
                            Button("+"){
                                Ttimenum = hour-5
                                self.showtimepicker.toggle()
                                
                            }
                            .frame(width: 20, height: 20,alignment: .top)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2))
                            .sheet(isPresented: $showtimepicker, onDismiss: {
                                for (index,item) in Ttime.enumerated() {
                                    Ttime[index].sort()
                                }
                            }){
                                playerPicker(Ttime: $Ttime[Ttimenum])
                            }
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
                        self.presentationMode.wrappedValue.dismiss()})
                    )
                }
                .padding()
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
