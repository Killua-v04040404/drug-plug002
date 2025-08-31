//
//  statsmainview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//


import SwiftUI

struct StatsMainView: View {
    @EnvironmentObject var statsManager: StatsManager
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Your Focus Journey")
                .font(.title.weight(.medium))
                .foregroundColor(.white)
            
            // Today's Stats
            VStack(alignment: .leading, spacing: 16) {
                Text("TODAY'S DAMAGE")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.gray)
                    .tracking(1)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                    ModernStatCard(
                        title: "Sessions",
                        value: "\(statsManager.todaysSessions)",
                        color: .orange,
                        icon: "target"
                    )
                    
                    ModernStatCard(
                        title: "Focus Time",
                        value: statsManager.formattedTodaysTime,
                        color: .red,
                        icon: "clock.fill"
                    )
                    
                    ModernStatCard(
                        title: "Streak",
                        value: "\(statsManager.currentStreak)",
                        color: .green,
                        icon: "flame.fill"
                    )
                }
            }
            
            // All Time Stats
            VStack(alignment: .leading, spacing: 16) {
                Text("ALL TIME STATS")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.gray)
                    .tracking(1)
                
                HStack(spacing: 16) {
                    ModernStatCard(
                        title: "Total Sessions",
                        value: "\(statsManager.totalSessions)",
                        color: .purple,
                        icon: "infinity"
                    )
                    
                    ModernStatCard(
                        title: "Total Time",
                        value: statsManager.formattedTotalTime,
                        color: .blue,
                        icon: "hourglass"
                    )
                }
            }
            
            Spacer()
        }
    }
}

struct ModernStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.05),
                            Color.white.opacity(0.02)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [color.opacity(0.3), color.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}
