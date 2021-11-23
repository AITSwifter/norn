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
