//
//  InputMyTableView.swift
//  norn
//
//  Created by nissy on 2021/10/12.
//

import Foundation
import SwiftUI
import Combine

struct InputMyTableView: View{
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var nameeditting = false
    @State private var start = ""
    @State private var starteditting = false
    @State private var end = ""
    @State private var endeditting = false
    @State private var midd: [String] = [""]
    @State private var mideditting: [Bool] = [false]
    @State private var needtime: [Int16] = [0]
    @State private var neededitting: [Bool] = [false]
    
    var middisVoid: Bool{
        return midd.count > 1
    }
    
//    struct tabledata{
//        var middtext: String
//        var mideitting: Bool
//        var needtime: Int16
//        var neededitting: Bool
//
//        init(mideitting: Bool,middtext: String,neededitting: Bool){
//            self.mideitting = mideitting
//            self.middtext = middtext
//            self.neededitting = neededitting
//        }
//    }
//
//    var controls:[tabledata] = []
    
    
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
                TextField("プリセット名",text: $name,
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
                ScrollView{
                    VStack{
                        //出発駅名の入力欄
                        TextField("出発駅名",text: $start,
                                  onEditingChanged: { begin in
                                    /// 入力開始処理
                                    if begin {
                                        self.starteditting = true
                                        // 編集フラグをオン
                                        /// 入力終了処理
                                    } else {
                                        self.starteditting = false   // 編集フラグをオフ
                                    }
                                  })
                            //入力中に枠を青く強調表示
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            // 編集フラグがONの時に枠に影を付ける
                            .shadow(color: starteditting ? .blue : .clear, radius: 3)
                        
                        HStack{
                            Text("↓")
                                .padding()
                            Text("所要時間")
                            TextField("分",value: $needtime[0], formatter: NumberFormatter(),onEditingChanged: { begin in
                                /// 入力開始処理
                                if begin {
                                    self.neededitting[0] = true
                                    // 編集フラグをオン
                                    /// 入力終了処理
                                } else {
                                    self.neededitting[0] = false   // 編集フラグをオフ
                                }
                            })
                            .padding()
                            .keyboardType(.numberPad)
                            .frame(width: 70)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .shadow(color: neededitting[0] ? .blue : .clear, radius: 3)
                            Text("分")
                                .frame(alignment: .leading)
                            
                        }
                        VStack{
                            ForEach(1..<midd.count,id: \.self) { index in
                                
                                VStack{
                                    
                                    TextField("途中駅名",text: $midd[index-1],
                                              onEditingChanged: { begin in
                                                /// 入力開始処理
                                                if begin {
                                                    self.mideditting[index] = true
                                                    // 編集フラグをオン
                                                    /// 入力終了処理
                                                } else {
                                                    self.mideditting[index] = false   // 編集フラグをオフ
                                                }
                                              })
                                        //入力中に枠を青く強調表示
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                        // 編集フラグがONの時に枠に影を付ける
                                        .shadow(color: mideditting[index] ? .blue : .clear, radius: 3)

                                    HStack{
                                        
                                        Text("↓")
                                            .padding()
                                        Text("所要時間")
                                        TextField("分",value: $needtime[index-1], formatter: NumberFormatter(),onEditingChanged: { begin in
                                            /// 入力開始処理
                                            if begin {
                                                self.neededitting[index] = true
                                                // 編集フラグをオン
                                                /// 入力終了処理
                                            } else {
                                                self.neededitting[index] = false   // 編集フラグをオフ
                                            }
                                        })
                                        .padding()
                                        .keyboardType(.numberPad)
                                        .frame(width: 70)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .shadow(color: neededitting[index] ? .blue : .clear, radius: 3)

                                        Text("分")
                                            .frame(alignment: .leading)
                                    }
                                }
                                
                            }
                            
                        }
                        //到着駅名の入力欄
                        TextField("到着駅名",text: $end,
                                  onEditingChanged: { begin in
                                    /// 入力開始処理
                                    if begin {
                                        self.endeditting = true
                                        // 編集フラグをオン
                                        /// 入力終了処理
                                    } else {
                                        self.endeditting = false   // 編集フラグをオフ
                                    }
                                  })
                            //入力中に枠を青く強調表示
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            // 編集フラグがONの時に枠に影を付ける
                            .shadow(color: endeditting ? .blue : .clear, radius: 3)
                        
                        
                    }
                }
                .padding()
                
                HStack{
                    Button("途中駅追加",action: {
                        self.midd.append("")
                        self.mideditting.append(false)
                        self.needtime.append(0)
                        self.neededitting.append(false)
                    })
                    .padding()
                    Button("途中駅削除",action: {
                        self.midd.removeLast()
                        self.mideditting.removeLast()
                        self.needtime.removeLast()
                        self.neededitting.removeLast()

                    })
                    .padding()
                    .disabled(!middisVoid)
                }
                Button("保存",action: {
                    
                    Savemytable()
                })
                .padding()
            }
            
            
            
            
        }
        .navigationBarTitle("プリセット入力画面",displayMode: .inline)
    }
    
    func Savemytable(){
        let newmytable = Mytable(context: context)
        
    }
    
}

struct InputMyTableView_Previews: PreviewProvider {
    static var previews: some View {
        InputMyTableView()
    }
}
