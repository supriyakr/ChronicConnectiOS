//
//  ContentView.swift
//  ChronicConnect
//
//  Created by Supriya KR on 5/10/25.
//

import SwiftUI
import CoreData

// Import Search feature

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showPostCreation = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                // Home Feed Tab
                HomeFeedView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                // Search Tab
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(1)
                
                // Empty tab for post creation
                Color.clear
                    .tabItem {
                        Label("", systemImage: "plus.circle.fill")
                    }
                    .tag(2)
                
                // Placeholder for Notifications Tab
                Text("Notifications")
                    .tabItem {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    .tag(3)
                
                // Profile Tab
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(4)
            }
            .onChange(of: selectedTab) { oldValue, newValue in
                if newValue == 2 {
                    // Reset tab selection and show post creation
                    selectedTab = 0
                    showPostCreation = true
                }
            }
            
            // Floating action button for post creation
            if !showPostCreation && selectedTab != 2 {
                Button(action: {
                    showPostCreation = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .offset(y: -15) // Position above tab bar
            }
        }
        .sheet(isPresented: $showPostCreation) {
            PostCreationView()
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, CoreDataStack.shared.viewContext)
}
