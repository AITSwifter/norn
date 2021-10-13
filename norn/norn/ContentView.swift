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
    //Timetableリストをtablesとして
        private var tables: FetchedResults<Timetable>
    var body: some View {
        ZStack{
            NavigationView{
                ZStack{
                    if tables.isEmpty{
                        Text("no data")
                    }else{
                        //リストの出力
                        List{
                            ForEach(tables,id:\.id){table in
                                HStack{
                                    Text(table.name ?? "unKown")
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                //リストの要素をタップしたら
                                .onTapGesture {
                                    
                                    deletetable()
                                }
                            }
                        }
                    }
                    //ボタンの表示
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            NavigationLink("＋", destination: InputMyTableView())
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

//UIApplicationを拡張してキーボードを閉じる関数を実装
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
