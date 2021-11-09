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
    case mytimetable
}


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Timetable.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Timetable>
    @State private var selection: TabType = .timetable
    @State private var chageview = AddTimeTable()
    
    @ViewBuilder func returnview() -> some View{
        
        switch selection {
        case .timetable:
            AddTimeTable()
        case .mytimetable:
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
                                MyTableTabView()
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
    
    private func addItem() {
        withAnimation {
            let newItem = Timetable(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
