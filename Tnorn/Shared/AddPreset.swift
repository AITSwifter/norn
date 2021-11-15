//
//  AddPreset.swift
//  Tnorn
//
//  Created by nissy on 2021/11/01.
//

import SwiftUI
import CoreData

struct AddPreset: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var nameeditting = false
    @State private var start = ""
    @State private var starteditting = false
    @State private var sdirect = ""
    @State private var sdirecteditting = false
    @State private var end = ""
    @State private var endeditting = false
    @State private var edirect = ""
    @State private var edirecteditting = false
    @State private var midd: [String] = ["1"]
    @State private var mideditting: [Bool] = [false]
    @State private var needtime: [Int] = [0]
    @State private var neededitting: [Bool] = [false]
    @State private var showingAlert = false
    
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
                
                ScrollView{
                    VStack{
                        HStack{
                            //出発駅名の入力欄
                            CustomTextField(iseditting: self.$starteditting, variable: $start, text: "出発駅名")
                            CustomTextField(iseditting: self.$sdirecteditting, variable: $sdirect, text: "方面")

                        }
                                                
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
                        HStack{
                            CustomTextField(iseditting: self.$endeditting, variable: $end, text: "到着駅名")
                            CustomTextField(iseditting: self.$edirecteditting, variable: $edirect, text: "方面")

                        }
                        
                        
                        
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
                    self.showingAlert = true
                    Savepreset(name: name, start: start, sdirect: sdirect, end: end, edirect: edirect)
                    
                })
                .disabled(!textisVoid)
                .padding()
                .alert(isPresented: $showingAlert) {
                            Alert(title: Text("タイトル"),
                                  message: Text("詳細メッセージです"),
                                  dismissButton: .default(Text("了解"),
                                                          action: {print("了解がタップされた")})) // ボタンがタップされた時の処理
                        }
            }
            
            
            
            
        }
        .navigationBarTitle("プリセット入力画面",displayMode: .inline)
    }
    
    func Savepreset(name: String, start: String, sdirect: String, end: String, edirect: String){
        let newpreset = Preset(context: context)
        newpreset.name = name
        newpreset.start = start
        newpreset.sdirect = sdirect
        newpreset.end = end
        newpreset.edirect = edirect
        newpreset.timestamp = Date()
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

}

struct AddPreset_Previews: PreviewProvider {
    static var previews: some View {
        AddPreset()
    }
}
