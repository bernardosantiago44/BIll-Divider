//
//  ContentView.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 17/04/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: Store
    @ObservedObject var settings: UserSettings
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        if self.horizontalSizeClass == .compact {
            TabView {
                
                NavigationView {
                    BillDivider(store: self.store, settings: self.settings)
                }
                .tabItem {
                    Text("divider")
                    Image(systemName: "arrow.triangle.branch")
                }
                .tag(NavigationTabs.Divider)
                NavigationView {
                    Records(store: self.store, settings: self.settings)
                }
                .tabItem {
                    Text("records")
                    Image(systemName: "clock")
                }
                .tag(NavigationTabs.Records)
                //            Currencies()
                //                .tabItem {
                //                    Text("currencies")
                //                    Image(systemName: "dollarsign.circle")
                //                }
                NavigationView {
                    Settings(store: self.store, settings: self.settings)
                }
                .tabItem {
                    Text("settings")
                    Image(systemName: "gear")
                }
                .tag(NavigationTabs.Settings)
            }
            .fullScreenCover(isPresented: self.$settings.showOnboarding) {
                Onboarding(settings: self.settings)
            }
        } else {
            NavigationView {
                SidebarNavigationList(store: self.store, settings: self.settings)
                BillDivider(store: self.store, settings: self.settings)
            }
            .fullScreenCover(isPresented: self.$settings.showOnboarding) {
                Onboarding(settings: self.settings)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(), settings: UserSettings())
            .previewInterfaceOrientation(.portrait)
    }
}
