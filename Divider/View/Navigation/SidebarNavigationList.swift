//
//  SidebarNavigationList.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 21/06/22.
//

import SwiftUI

struct SidebarNavigationList: View {
    @ObservedObject var store: Store
    @ObservedObject var settings: UserSettings
    var body: some View {
        List {
            // Bill Divider
            NavigationLink(tag: NavigationTabs.Divider, selection: self.$settings.tabSelection) {
                BillDivider(store: self.store, settings: self.settings)
            } label: {
                Label {
                    Text("divider")
                } icon: {
                    Image(systemName: "arrow.triangle.branch")
                }
            }
            
            // Records
            NavigationLink(tag: NavigationTabs.Records, selection: self.$settings.tabSelection) {
                Records(store: self.store, settings: self.settings)
            } label: {
                Label {
                    Text("records")
                } icon: {
                    Image(systemName: "clock")
                }
            }
            
            // Settings
            NavigationLink(tag: NavigationTabs.Settings, selection: self.$settings.tabSelection) {
                Settings(store: self.store, settings: self.settings)
            } label: {
                Label {
                    Text("settings")
                } icon: {
                    Image(systemName: "gear")
                }
            }

        }
        .listStyle(.sidebar)
        .navigationTitle("tabs")
    }
}

struct SidebarNavigationList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SidebarNavigationList(store: Store(), settings: UserSettings())
        }
    }
}
