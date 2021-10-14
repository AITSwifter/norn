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
    @State private var midd: [String] = ["1"]
    @State private var mideditting: [Bool] = [false]
    @State private var needtime: [Int16] = [0]
    @State private var neededitting: [Bool] = [false]
    
    var middisCount: Bool{
        return 1 < mideditting.count
    }
    
    var textisVoid: Bool{
        var midflg = true
        if middisCount {
            midd.forEach{
                midflg = midflg && !$0.isEmpty
            }
        }
        
        return !start.isEmpty && !end.isEmpty && !name.isEmpty && midflg
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
                CustomTextField(iseditting: self.$nameeditting, variable: $name, text: "プリセット名")
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
                        CustomTextField(iseditting: self.$starteditting, variable: $start, text: "出発駅名")
                                                
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
                                    CustomTextField(iseditting: self.$mideditting[index-1], variable: $midd[index-1], text: "途中駅名")

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
                        CustomTextField(iseditting: self.$endeditting, variable: $end, text: "到着駅名")
                                               
                        
                    }
                }
                .padding()
                
                HStack{
                    Button("途中駅追加",action: {
                        self.midd.insert("", at: 0)
                        self.mideditting.insert(false, at: 0)
                        self.needtime.insert(0, at: 0)
                        self.neededitting.insert(false, at: 0)
                    })
                    .padding()
                    Button("途中駅削除",action: {
                        self.midd.removeFirst()
                        self.mideditting.removeFirst()
                        self.needtime.removeFirst()
                        self.neededitting.removeFirst()

                    })
                    .padding()
                    .disabled(!middisCount)
                }
                Button("保存",action: {
                    
                    Savemytable()
                })
                .disabled(!textisVoid)
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
