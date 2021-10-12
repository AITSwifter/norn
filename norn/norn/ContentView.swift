//
//  ContentView.swift
//  norn
//
//  Created by nissy on 2021/10/05.
//

import SwiftUI

enum display {
    case main
    case input
}


struct ContentView: View {
    /// 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
        @Environment(\.managedObjectContext) private var context
     
        /// データ取得処理
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Timetable.timestamp, ascending: true)],
            animation: .default)
        private var tables: FetchedResults<Timetable>
    var body: some View {
        ZStack{
            NavigationView{
                ZStack{
                    if tables.isEmpty{
                        Text("no data")
                    }else{
                        List{
                            ForEach(tables,id:\.id){table in
                                HStack{
                                    Text(table.name ?? "unKown")
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    
                                    deletetable()
                                    }

                                
                            }
                        }

                    }
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            NavigationLink("＋", destination: InputView())
                                .font(.system(size: 30))
                                .frame(width: 50, height: 50)
                                .background(Color.red)
                                .clipShape(Circle())
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
    func deletetable(){
        context.delete(tables[0])
    }
}

struct InputView: View{
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var Ttime = 0
    @State private var nameeditting = false
    @State private var Ttimeeditting = false
    @State private var showingAlert = false
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
                
                //時刻表の入力欄
                TextField("時刻表",text: $Ttime.IntToStrDef(0),
                          onEditingChanged: { begin in
                            /// 入力開始処理
                            if begin {
                                self.Ttimeeditting = true
                                // 編集フラグをオン
                                /// 入力終了処理
                            } else {
                                self.Ttimeeditting = false   // 編集フラグをオフ
                            }
                          })
                    //入力中に枠を青く強調表示
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    // 編集フラグがONの時に枠に影を付ける
                    .shadow(color: Ttimeeditting ? .blue : .clear, radius: 3)
                
                
                Button(action: {
                    self.showingAlert = true
                    savetable(text: name, num: Ttime)
                    /// 現在のViewを閉じる
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("保存")
                }
                .alert(isPresented: $showingAlert){
                    Alert(title: Text("保存"),
                          message: Text("\(name)を保存しました")
                    )
                }
                .padding()
                
                
            }
        }
        
        .navigationBarTitle("入力画面")
        
    }
    
    func savetable(text: String, num: Int){
        /// 時刻表新規登録処理
        let newTtable = Timetable(context: context)
        newTtable.name = text
        newTtable.timetable = Int16(num)
        newTtable.timestamp = Date()
        try? context.save()
    }
    
    
    
}
//UIApplicationを拡張してキーボードを閉じる関数を実装
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Binding where Value == Int {
    func IntToStrDef(_ def: Int) -> Binding<String> {
        return Binding<String>(get: {
            return String(self.wrappedValue)
        }) { value in
            self.wrappedValue = Int(value) ?? def
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
