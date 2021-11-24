//
//  CustomVIew.swift
//  Tnorn
//
//  Created by nissy on 2021/10/20.
//

import SwiftUI

struct playerPicker: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding  var Ttime: [Int]
    @State var selectminute = 0
    @State var isalert = false
    
    var ischeckdup: Bool{
        return Ttime.firstIndex(of: selectminute) == nil
    }
    
    var body: some View {
        VStack{
            HStack{
                //ユーザが入力するピッカー
                Picker("分を入力" , selection: $selectminute){
                    ForEach(0..<60) { num in
                        Text(String(num)).tag(num)
                    }
                }
            }
            HStack{
                Button("戻る"){
                    self.presentationMode.wrappedValue.dismiss()
                }
                Button("完了"){
                    if ischeckdup{
                        Ttime.append(selectminute)
                        self.presentationMode.wrappedValue.dismiss()
                    } else{
                        isalert = true
                    }
                }
                .alert(isPresented: $isalert){
                    Alert(title: Text("その時間はすでに入力済みです"))
                }
            }
        }
    }
}

struct timeview: View{
    
    @Binding var Ttime: [Int]
    @Binding var showpicker: Bool
    @State var index: Int
    @Binding var keepTtime: Int
    @Binding var keeptime: Int
    @State var timenum: Int
    @State var isdelete = false
    
    
    var body: some View{
        Text(String(timenum))
            .onTapGesture {
                keepTtime = index
                keeptime = Ttime.firstIndex(of: timenum)!
                showpicker = true
            }
            .onLongPressGesture {
                isdelete = true
            }
            .alert(isPresented: $isdelete){
                Alert(title: Text("削除"), message: Text("この要素を削除しますか？"), primaryButton: .default(Text("取消")), secondaryButton: .destructive(Text("削除"),action: {
                    if Ttime.firstIndex(of: timenum) != nil {
                        Ttime.remove(at: Ttime.firstIndex(of: timenum)!)
                    }
                }))
                
            }
    }
}

struct timepicker: View{
    @Binding var showpicker: Bool
    @Binding var selectminute: Int
    @Binding var Ttime: [Int]
    var body: some View{
        VStack{
            Button(action: {
                self.showpicker = false
            }) {
                HStack {
                    Spacer() //右寄せにするため使用
                    Text("戻る")
                        .padding()
                }
            }
            Divider()
            List{
                ForEach(0..<60){ time in
                    Button(action: {
                        selectminute = time
                        Ttime.sort()
                        self.showpicker = false
                    }) {
                        Text(String(time))
                    }
                    .disabled(Ttime.firstIndex(of: time) != nil)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct testdelete: View{
    @Binding var Ttime: [Int]
    @State var time: Int
    @State var isdelete = false
    
    var body: some View{
        Text(String(time))
            .onLongPressGesture {
                isdelete = true
            }
            .alert(isPresented: $isdelete){
                Alert(title: Text("削除"), message: Text("\(time)を削除しますか？"), primaryButton: .default(Text("取消")), secondaryButton: .destructive(Text("削除"),action: {
                    if Ttime.firstIndex(of: time) != nil {
                        Ttime.remove(at: Ttime.firstIndex(of: time)!)
                    }
                }))
            }
        
    }
}

//文字列を入力
struct CustomTextField: View {
    
    @Binding var variable: String
    @State var iseditting = false
    @State var text: String
    
    
    var body: some View{
        TextField("\(text)",text: $variable,
                  onEditingChanged: { begin in
            /// 入力開始処理
            if begin {
                self.iseditting = true
                // 編集フラグをオン
                /// 入力終了処理
            } else {
                self.iseditting = false   // 編集フラグをオフ
            }
        })
        //入力中に枠を青く強調表示
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        // 編集フラグがONの時に枠に影を付ける
            .shadow(color: iseditting ? .blue : .clear, radius: 3)
        
    }
}

//数字入力
struct NumberField: View {
    @Binding var variable: Int
    @State var iseditting = false
    @State var text: String
    
    var body: some View{
        TextField("\(text)",value: $variable, formatter: NumberFormatter(),
                  onEditingChanged: { begin in
            /// 入力開始処理
            if begin {
                self.iseditting = true
                // 編集フラグをオン
                /// 入力終了処理
            } else {
                self.iseditting = false   // 編集フラグをオフ
            }
        })
        //入力中に枠を青く強調表示
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        // 編集フラグがONの時に枠に影を付ける
            .shadow(color: iseditting ? .blue : .clear, radius: 3)
        
    }
}

// 駅の名前と方面を入力
struct InputStation: View{
    @Binding var name: String
    @Binding var direction: String
    
    var body: some View{
        HStack{
            CustomTextField(variable: $name, text: "駅名")
            CustomTextField(variable: $direction, text: "方面")
        }
    }
}
