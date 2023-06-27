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
        .onAppear(perform: {Task {await subscribeTodos()}})
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
    
    func subscribeTodos() async {
      do {
          
          print("I am here")
          
          let mutationEvents = Amplify.DataStore.observe(Todo.self)
          for try await mutationEvent in mutationEvents {
              print("Subscription got this value: \(mutationEvent)")
              do {
                  let todo = try mutationEvent.decodeModel(as: Todo.self)
                  
                  switch mutationEvent.mutationType {
                  case "create":
                      print("Created: \(todo)")
                  case "update":
                      print("Updated: \(todo)")
                  case "delete":
                      print("Deleted: \(todo)")
                  default:
                      break
                  }
                  
                  print(todo)
                  
              } catch {
                  print("Model could not be decoded: \(error)")
              }
          }
          
          await refreshItems()
          
      } catch {
          print("Unable to observe mutation events")
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
