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
    @State private var start = ""
    @State private var sdirect = ""
    @State private var middname: [String] = [""]
    @State private var midddir: [String] = [""]
    @State private var needtime: [Int] = [10]
    @State private var showingAlert = false
    
    var textisVoid: Bool{
        return !start.isEmpty && !name.isEmpty && !sdirect.isEmpty && checklistEnpty
    }
    
    var checklistEnpty: Bool{
        return middname.firstIndex(of: "") == nil && midddir.firstIndex(of: "") == nil
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
                              message: Text("\(name)を保存していいですか？"),
                              primaryButton:
                                    .cancel(Text("CANCEL")),
                              secondaryButton: .default(Text("OK"),

                                                        action: {

                            Savepreset(name: name, start: start, sdirect: sdirect, middname: middname, midddir:  midddir,needtime: needtime)
                            self.presentationMode.wrappedValue.dismiss()}))                         }
            }
            
            
            
            
        }
        .navigationBarTitle("プリセット入力画面",displayMode: .inline)
    }
    

    func Savepreset(name: String, start: String, sdirect: String, middname: [String], midddir: [String], needtime: [Int]){

        let newpreset = Preset(context: context)
        newpreset.name = name
        newpreset.start = start
        newpreset.sdirect = sdirect
        newpreset.middname = middname
        newpreset.midddir = midddir
        newpreset.needtime = needtime
        newpreset.timestamp = Date()
        try? context.save()
    }
}


struct AddPreset_Previews: PreviewProvider {
    static var previews: some View {
        AddPreset()
    }
}
