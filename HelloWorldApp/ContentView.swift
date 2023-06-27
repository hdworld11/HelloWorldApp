//
//  ContentView.swift
//  HelloWorldApp
//
//  Created by Daddala, Harshita on 6/27/23.
//

import SwiftUI
import Amplify

struct ContentView: View {
    
    @State private var itemName: String = ""
    @State private var itemDescription: String = ""
    @State private var itemList: [Todo] = [Todo]()
    
    @EnvironmentObject private var viewModel: ViewModel
    
    var body: some View {
        VStack {
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            #if os(iOS) || os(macOS)
            TextField("Name", text: $itemName)
            TextField("Description", text: $itemDescription)
            
            Button("Add Item",
                   action: {
                            Task{
                              await performOnClick(itemName: itemName, itemDescription: itemDescription)
                            }
                    }
            )
            #endif
            
            List{
                ForEach(itemList, id: \.id){ item in
                    Text(item.name)
                }
            }
            
            #if os(iOS)
                Text("Hello, iOS!")
            #elseif os(macOS)
                Text("Hello, macOS!")
            #elseif os(tvOS)
                Text("Hello, tvOS!")
            #endif
        }
        .padding()
        .onAppear(perform: {Task {await viewModel.subscribeTodos()}})
    }
    
    
    func performOnClick(itemName: String, itemDescription: String) async {
        do {
            let item = Todo(name: itemName,
                            description: itemDescription)
            let savedItem = try await Amplify.DataStore.save(item)
            print("Saved item: \(savedItem.name)")
            
            await refreshItems()
            
        } catch {
            print("Could not save item to DataStore: \(error)")
        }
    }
    
    func refreshItems() async {
        do {
            let todos = try await Amplify.DataStore.query(Todo.self)
            
            itemList.removeAll()
            
            print("I am now here")
            
            for todo in todos {
                print("==== Todo ====")
                print("Name: \(todo.name)")
                if let description = todo.description {
                    print("Description: \(description)")
                }
                
                itemList.append(todo)
            }
        } catch {
            print("Could not query DataStore: \(error)")
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
