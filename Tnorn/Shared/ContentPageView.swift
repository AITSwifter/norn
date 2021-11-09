//
//  ContentPageView.swift
//  Tab
//
//  Created by k20028kk on 2021/10/19.
//

import SwiftUI

struct ContentPageView: View {
    
    @Binding var selection: TabType
    
    var body: some View{
        TabView(selection: $selection){
            TableTabView().tag(TabType.timetable)
            MyTableTabView().tag(TabType.mytimetable)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

//時刻表
extension String: Identifiable {
    public var id: String { self }
}

struct TableTabView: View {
    @State var names = ["八草","高蔵寺","新豊田"]
    @State var aa = [test]()
    @State var Ttime1 = [[11,12],[11,12],[11,12],[11,12],[11,12],[5,11,12],[11,12],[11,12],[11,12],[12,13],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12]]
    @State var Ttime2 = [[1,2],[11,12],[11,12],[11,12],[11,12],[5,11,12],[11,12],[11,12],[11,12],[12,13],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12],[11,12]]
    @State private var selectname: String? = nil
    
    func bb(nameee:String) -> [[Int]]{
        
        if nameee == names[0]{
            return self.Ttime1
        }
        if nameee == names[1]{
            return self.Ttime2
        }
        return [[1]]
    }
    
    var body: some View{
        NavigationView{
            ZStack{
                List{
                    ForEach(names, id: \.self) { user in
                        HStack{
                            Text(user)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture{
                            self.selectname = user
                        }
                        .sheet(item: self.$selectname, content: { selectname in
                            DetailView(Ttime: bb(nameee:selectname),name:selectname)
                        })
                        //データ削除
                    }.onDelete { offsets in
                        self.names.remove(atOffsets: offsets)
                    }
                }
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        NavigationLink("＋", destination: AddTimeTable())
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

struct test {
    var name:String
    var aaa:[[Int]]
    init(name:String,aaa:[[Int]]){
        self.name=name
        self.aaa=aaa
    }
}


//時刻表プレビュー
struct DetailView: View {
    @State var Ttime:[[Int]]
    @State var name:String
    var body: some View {
        Text(name)
        List{
            ForEach(5..<25) { hour in
                HStack{
                    Text("\(hour)")
                        .frame(width: 30)
                    Divider()
                    ScrollView(.horizontal, showsIndicators: true){
                        HStack{
                            ForEach(Ttime[hour-5], id: \.self) { time in
                                Text(String(time))
                                //}.onDelete { offsets in
                                //  self.Ttime.remove(atOffsets: offsets)
                            }
                        }
                    }
                }
            }
        }
    }
}



struct test2 {
    var data:String
    var ccc:[String]
    init(data:String,ccc:[String]){
        self.data=data
        self.ccc=ccc
    }
    
}


//プリセット
struct MyTableTabView: View {
    @State var datas = ["通学","通勤","帰宅"]
    @State private var selectnamee: String? = nil
    
    @State var ee = [test2]()
    @State var Tdata1 = ["八草","10","新豊田","岡崎"]//[出発,時間,中間,到着]
    @State var Tdata2 = ["岡崎","30","新豊田","八草"]//[出発,時間,中間,到着]
    
    
    func cc(dataaa:String) -> [String]{
        
        if dataaa == datas[0]{
            return self.Tdata1
        }
        if dataaa == datas[1]{
            return self.Tdata2
        }
        return [""]
    }
    
    
    var body: some View{
        NavigationView{
            ZStack{
                List{
                    ForEach(datas, id: \.self) { user in
                        HStack{
                            Text(user)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture{
                            self.selectnamee = user
                            
                        }
                        
                        .sheet(item: self.$selectnamee, content: { selectnamee in
                            DetailView2(Tdata: cc(dataaa:selectnamee),data:selectnamee)
                            
                        })
                    }.onDelete { offsets in
                        self.datas.remove(atOffsets: offsets)
                    }
                }
                
            }
            
        }
    }
}


//プリセットプレビュー
struct DetailView2: View {
    
    @State var Tdata:[String]
    @State var data:String
    var body: some View {
        Text(data)
        List{
            ForEach(Tdata, id: \.self) { data in
                Text(String(data))
                
            }
            
        }
    }
}


