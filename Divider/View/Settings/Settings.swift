//
//  Settings.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 15/06/22.
//

import SwiftUI

struct Settings: View {
    @ObservedObject var store: Store
    @ObservedObject var settings: UserSettings
    var body: some View {
        
        List {
            Section {
                NavigationLink {
                    CategoriesManager(store: self.store)
                } label: {
                    Text("my_categories")
                }
            } header: {
                Text("categories")
            }
            
            Section {
                NavigationLink {
                    CurrencyCodePicker(settings: self.settings)
                } label: {
                    HStack {
                        Text("currencies")
                        Spacer()
                        Text(settings.currencyFormat)
                            .foregroundColor(.gray)
                    }
                }
            } header: {
                Text("currencies")
            }
            
            Section {
                Button(action: openAppSettings, label: {
                    Text("language")
                })
            } header: {
                Text("ui_settings")
            }
            
            Section {
                Button {
                    self.settings.showOnboarding = true
                } label: {
                    Text("show_onboarding")
                        .foregroundColor(.primary)
                }
                
                NavigationLink {
                    Privacy_Policiy(store: self.store)
                } label: {
                    Text("privacy")
                }

                
                HStack {
                    Text("app_version")
                    Spacer()
                    Text(getCurrentAppVersion())
                        .foregroundColor(.secondary)
                }

            } header: {
                Text("information")
            }
        }
        .navigationTitle("settings")
        
    }
}

func openAppSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Settings(store: Store(), settings: UserSettings())
        }
    }
}
