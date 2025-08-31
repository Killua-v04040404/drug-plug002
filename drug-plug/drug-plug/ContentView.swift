//
//  ContentView.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @EnvironmentObject var musicPlayer: MusicPlayerService
    @EnvironmentObject var statsManager: StatsManager
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                HStack(spacing: 0) {
                    // Sidebar Navigation
                    SidebarView()
                        .frame(width: 80)
                        .background(Color.black.opacity(0.2))
                    
                    // Main Content Area
                    VStack(spacing: 0) {
                        // Top Header
                        TopHeaderView()
                            .padding(.horizontal, 40)
                            .padding(.top, 32)
                        
                        // Content based on selected view
                        ScrollView {
                            VStack(spacing: 40) {
                                switch appState.selectedTab {
                                case .timer:
                                    TimerMainView()
                                case .stats:
                                    StatsMainView()
                                case .music:
                                    MusicMainView()
                                case .settings:
                                    SettingsMainView()
                                }
                            }
                            .padding(.horizontal, 40)
                            .padding(.bottom, 40)
                            .frame(minHeight: geometry.size.height - 120)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.95, green: 0.95, blue: 0.97),
                                Color(red: 0.92, green: 0.92, blue: 0.95)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}

struct TopHeaderView: View {
    @EnvironmentObject var statsManager: StatsManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text("FOCUS")
                            .font(.title.weight(.heavy))
                            .foregroundColor(.black)
                        Text("PLUG")
                            .font(.title.weight(.heavy))
                            .foregroundColor(.red)
                    }
                    
                    Text("Your drug dealer for focus 💊")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Streak indicator
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.title3)
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("\(statsManager.currentStreak)")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.orange)
                        Text("day streak")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                )
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
        .environmentObject(TimerManager())
        .environmentObject(WebsiteBlockerService())
        .environmentObject(MusicPlayerService())
        .environmentObject(StatsManager())
}
