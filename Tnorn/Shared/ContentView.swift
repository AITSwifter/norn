//
//  ContentView.swift
//  Shared
//
//  Created by nissy on 2021/10/19.
//

import SwiftUI
import CoreData

enum display{
    case output
    case addtable
    case addpreset
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Timetable.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Timetable>

    var body: some View {
        NavigationView {
            VStack{
                Text(String(items.count))
                List {
                    ForEach(items) { item in
                        NavigationLink(destination: OutputView()) {
                            HStack{
                                Text(item.name ?? "Item")
                                Text("to \(item.direction ?? "out")" )
                                Text(item.timestamp!, formatter: itemFormatter)
                            }
                            
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
    #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddPreset()){
                            Label("Add preset", systemImage: "plus")
                        }
                    }
    #endif
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddTimeTable()){
                            Label("Add Item", systemImage: "plus").foregroundColor(.red)
                        }
                    }
                    
                    
                }
                Text("Select an item")
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
