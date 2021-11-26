//
//  ContentView.swift
//  Shared
//
//  Created by nissy on 2021/10/19.
//

import SwiftUI
import CoreData

enum TabType: Int {
    case timetable
    case preset
}


struct ContentView: View {
    
//    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selection: TabType = .timetable
        
    @ViewBuilder func returnview() -> some View{
        
        switch selection {
        case .timetable:
            AddTimeTable()
        case .preset:
            AddPreset()
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                GeometryReader { geometry in
                    NavigationView {
                        VStack(spacing: .zero) {
                            UpperTabView(selection: $selection,
                                         geometrySize: geometry.size)
                            if selection == .timetable {
                                TableTabView()
                            } else{
                                PresetTabView()
                            }
                        }
                        .navigationBarHidden(true)
                    }

                }
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        NavigationLink("＋", destination: returnview())
                            .font(.system(size: 30))
                            .frame(width: 50, height: 50)
                            .background(Color.red)
                            .clipShape(Circle())
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                            .foregroundColor(.white)
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//UIApplicationを拡張してキーボードを閉じる関数を実装
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
