//
//  UserDefaults.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 19/06/22.
//

import Foundation

class UserSettings: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var showOnboarding: Bool {
        didSet {
            defaults.set(showOnboarding, forKey: "show_onboarding")
        }
    }
    
    @Published var tabSelection: NavigationTabs? = .Divider
    
    @Published var currencyFormat: String {
        didSet {
            defaults.set(currencyFormat, forKey: "currency_format")
        }
    }
    
    @Published var showWhatsNew: Bool {
        didSet {
            defaults.set(showWhatsNew, forKey: "show_changes")
        }
    }
    
    init() {
        self.currencyFormat = defaults.string(forKey: "currency_format")  ?? Locale.current.currencyCode ?? "USD"
        self.showOnboarding = defaults.object(forKey: "show_onboarding") as? Bool ?? true
        self.showWhatsNew = defaults.bool(forKey: "show_changes")
    }
}

func getCurrentAppVersion() -> String {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
    
    let version = (appVersion as! String)
    
    return version
}
