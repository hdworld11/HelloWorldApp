//
//  HelloWorldAppApp.swift
//  HelloWorldApp
//
//  Created by Daddala, Harshita on 6/27/23.
//

import SwiftUI
import Amplify
import AWSAPIPlugin
import AWSDataStorePlugin

@main
struct HelloWorldAppApp: App {
    
    init() {
        let apiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels())
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
        do {
            try Amplify.add(plugin: apiPlugin)
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.configure()
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
