//
//  ContentView.swift
//  SustainaBuddy
//
//  Created by SustainaBuddy Team
//

import SwiftUI
import MapKit



struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
                MarineTrackerView()
                    .tabItem {
                        Image(systemName: TabType.marineTracker.iconName)
                        Text(TabType.marineTracker.rawValue)
                    }
                    .tag(TabType.marineTracker)
                
                SustainaBuddyView()
                    .tabItem {
                        Image(systemName: TabType.sustainaBuddy.iconName)
                        Text(TabType.sustainaBuddy.rawValue)
                    }
                    .tag(TabType.sustainaBuddy)
                
                EcoFootprintView()
                    .tabItem {
                        Image(systemName: TabType.ecoFootprint.iconName)
                        Text(TabType.ecoFootprint.rawValue)
                    }
                    .tag(TabType.ecoFootprint)
                
                EcoDiningView()
                    .tabItem {
                        Image(systemName: TabType.dining.iconName)
                        Text(TabType.dining.rawValue)
                    }
                    .tag(TabType.dining)
                
                SocialView()
                    .tabItem {
                        Image(systemName: TabType.social.iconName)
                        Text(TabType.social.rawValue)
                    }
                    .tag(TabType.social)
                
                AchievementView()
                    .tabItem {
                        Image(systemName: TabType.achievements.iconName)
                        Text(TabType.achievements.rawValue)
                    }
                    .tag(TabType.achievements)
                
                // ScientificInfoView()
                //     .tabItem {
                //         Image(systemName: TabType.scientificInfo.iconName)
                //         Text(TabType.scientificInfo.rawValue)
                //     }
                //     .tag(TabType.scientificInfo)
            }
        .accentColor(Color.cyan)
        .background(Color.sleekDark)
    }
}



// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
            .preferredColorScheme(.dark)
    }
}