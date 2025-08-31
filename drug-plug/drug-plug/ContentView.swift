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
        NavigationView {
            HStack(spacing: 0) {
                // Sidebar Navigation
                SidebarView()
                    .frame(width: 80)
                    .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
                
                // Main Content Area
                VStack(spacing: 0) {
                    // Top Header
                    TopHeaderView()
                        .padding(.horizontal, 32)
                        .padding(.top, 24)
                    
                    // Content based on selected view
                    ScrollView {
                        VStack(spacing: 32) {
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
                        .padding(.horizontal, 32)
                        .padding(.bottom, 32)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.08, green: 0.08, blue: 0.12),
                            Color(red: 0.05, green: 0.05, blue: 0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            }
        }
        .frame(minWidth: 900, minHeight: 700)
        .background(Color(red: 0.05, green: 0.05, blue: 0.08))
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
                            .foregroundColor(.white)
                        Text("PLUG")
                            .font(.title.weight(.heavy))
                            .foregroundColor(.red)
                    }
                    
                    Text("Your drug dealer for focus 💊")
                        .font(.caption)
                        .foregroundColor(.gray)
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
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
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
