//
//  InputtimeableView.swift
//  norn
//
//  Created by nissy on 2021/10/12.
//

import Foundation
import SwiftUI

struct InputTimeTableView: View{
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var nameeditting = false
    @State private var direction = ""
    @State private var direeditting = false
    @State private var Ttime: Int16?
    @State private var Ttimeeditting = false
    @State private var showingAlert = false
    
    @State private var ordinaly = true
    @State private var saturday = false
    @State private var holiday = false
    
    var textisVoid: Bool{
        return !name.isEmpty && !direction.isEmpty
    }
    
    var checkisVoid: Bool{
        return !ordinaly && !saturday && !holiday
    }
    
    var body: some View{
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
                    //駅名の入力欄
                    TextField("駅名",text: $name,
                              onEditingChanged: { begin in
                                /// 入力開始処理
                                if begin {
                                    self.nameeditting = true
                                    // 編集フラグをオン
                                    /// 入力終了処理
                                } else {
                                    self.nameeditting = false   // 編集フラグをオフ
                                }
                              })
                        //入力中に枠を青く強調表示
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        // 編集フラグがONの時に枠に影を付ける
                        .shadow(color: nameeditting ? .blue : .clear, radius: 3)
                    
                    //方面の入力
                    TextField("方面",text: $direction,
                              onEditingChanged: { begin in
                                /// 入力開始処理
                                if begin {
                                    self.direeditting = true
                                    // 編集フラグをオン
                                    /// 入力終了処理
                                } else {
                                    self.direeditting = false   // 編集フラグをオフ
                                }
                              })
                        //入力中に枠を青く強調表示
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        // 編集フラグがONの時に枠に影を付ける
                        .shadow(color: direeditting ? .blue : .clear, radius: 3)
                }
                
                HStack{
                    Toggle("平日",isOn: $ordinaly)
                        .toggleStyle(MyCheckboxToggleStyle())
                        .padding()
                    Toggle("土曜",isOn: $saturday)
                        .toggleStyle(MyCheckboxToggleStyle())
                        .padding()
                    Toggle("日祝",isOn: $holiday)
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
                                    ForEach(1..<60){ minut in
                                        Text("\(minut)")
                                    }
                                }
                            }
                            Divider()
                            Button("+"){
                                
                            }
                            .frame(width: 20, height: 20,alignment: .top)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                        }
                    }
                    
                }
                
                
                //                //時刻表の入力欄
                //                TextField("時刻表",value: $Ttime, formatter: NumberFormatter(),
                //                          onEditingChanged: { begin in
                //                            /// 入力開始処理
                //                            if begin {
                //                                self.Ttimeeditting = true
                //                                // 編集フラグをオン
                //                                /// 入力終了処理
                //                            } else {
                //                                self.Ttimeeditting = false   // 編集フラグをオフ
                //                            }
                //                          })
                //                    .keyboardType(.numberPad)
                //                    //入力中に枠を青く強調表示
                //                    .textFieldStyle(RoundedBorderTextFieldStyle())
                //                    .padding()
                //                    // 編集フラグがONの時に枠に影を付ける
                //                    .shadow(color: Ttimeeditting ? .blue : .clear, radius: 3)
                
                
                Button(action: {
                    self.showingAlert = true
                    savetable(text: name,direction: direction, num: Ttime ?? 0, ordinal: ordinaly, saturday: saturday, holiday: holiday)
                    /// 現在のViewを閉じる
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("保存")
                }
                .disabled(!textisVoid || checkisVoid)
                .alert(isPresented: $showingAlert){
                    Alert(title: Text("保存"),
                          message: Text("\(name)を保存しました")
                    )
                }
                .padding()
                
                
            }
        }
        
        .navigationBarTitle("時刻表入力画面",displayMode: .inline)
        
    }
    
    func savetable(text: String,direction: String, num: Int16, ordinal: Bool, saturday: Bool, holiday: Bool){
        /// 時刻表新規登録処理
        let newTtable = Timetable(context: context)
        newTtable.name = text
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


struct InputTimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        InputTimeTableView()
    }
}
