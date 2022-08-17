//
//  DividerApp.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 17/04/22.
//

import SwiftUI

@main
struct DividerApp: App {
    @StateObject var store: Store = Store()
    @StateObject var settings: UserSettings = UserSettings()
    @AppStorage("appVersionNumber") var appVersion: String = getCurrentAppVersion()
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: self.store, settings: self.settings)
        }
    }
}
