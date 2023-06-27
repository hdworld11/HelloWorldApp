//
//  ViewModel.swift
//  HelloWorldApp
//
//  Created by Daddala, Harshita on 6/27/23.
//

import Foundation
import SwiftUI
import Amplify

extension ContentView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        var itemsMutated:  AmplifyAsyncThrowingSequence<MutationEvent>?
        
        func subscribeTodos() async {
          do {
              
              print("I am here")
              
              let mutationEvents = Amplify.DataStore.observe(Todo.self)
              self.itemsMutated = mutationEvents
              
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
              
          } catch {
              print("Unable to observe mutation events")
          }
        }
    }
    
}
