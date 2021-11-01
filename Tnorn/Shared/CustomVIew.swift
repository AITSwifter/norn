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
    
    var body: some View {
        VStack(){
            HStack(){
                //ユーザが入力するピッカー
                Picker("分を入力" , selection: $selectminute){
                    ForEach(0..<60) { num in
                        Text(String(num)).tag(num)
                    }
                }
            }
            Button("完了"){
                Ttime.append(selectminute)
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct CustomTextField: View {
    @Binding var iseditting: Bool
    @Binding var variable: String
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
    @Binding var iseditting: Bool
    @Binding var variable: Int
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
