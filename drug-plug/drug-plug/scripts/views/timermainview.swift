//
//  timermainview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//

import SwiftUI

struct TimerMainView: View {
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @State private var showingTimerSettings = false
    
    var body: some View {
        VStack(spacing: 40) {
            // Focus Question Section
            VStack(spacing: 20) {
                Text("What's your focus?")
                    .font(.title.weight(.medium))
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                    Text("General")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.white)
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
                
                // Intention input
                TextField("Intention", text: .constant(""))
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.03))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
            
            // Circular Timer
            CircularTimerView()
            
            // Control Buttons
            HStack(spacing: 20) {
                Button(action: { showingTimerSettings = true }) {
                    Image(systemName: "timer")
                        .font(.title2.weight(.medium))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: toggleTimer) {
                    Text(timerManager.isRunning ? "STOP SESSION" : "START SESSION")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    LinearGradient(
                                        colors: timerManager.isRunning ?
                                        [Color.red, Color.red.opacity(0.8)] :
                                        [Color.red, Color.orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(
                                    color: timerManager.isRunning ? .red.opacity(0.4) : .orange.opacity(0.4),
                                    radius: 12,
                                    x: 0,
                                    y: 6
                                )
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(timerManager.isRunning ? 0.98 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: timerManager.isRunning)
                
                Button(action: { timerManager.reset() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2.weight(.medium))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(timerManager.isRunning)
                .opacity(timerManager.isRunning ? 0.5 : 1.0)
            }
            .padding(.horizontal, 40)
            
            // Quick Actions
            QuickActionsView()
                .padding(.horizontal, 40)
        }
        .sheet(isPresented: $showingTimerSettings) {
            TimerSettingsView()
        }
    }
    
    private func toggleTimer() {
        if timerManager.isRunning {
            timerManager.stop()
            blockerService.unblockAll()
        } else {
            timerManager.start()
            blockerService.blockWebsites()
        }
    }
}

struct CircularTimerView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        ZStack {
            // Background circle with tick marks
            ZStack {
                // Outer tick marks
                ForEach(0..<60, id: \.self) { tick in
                    Rectangle()
                        .fill(Color.white.opacity(tick % 5 == 0 ? 0.4 : 0.2))
                        .frame(width: tick % 5 == 0 ? 3 : 1, height: tick % 5 == 0 ? 20 : 12)
                        .offset(y: -140)
                        .rotationEffect(.degrees(Double(tick) * 6))
                }
                
                // Background circle
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 8)
                    .frame(width: 280, height: 280)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: timerManager.progress)
                    .stroke(
                        LinearGradient(
                            colors: [.red, .orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 280, height: 280)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: timerManager.progress)
                
                // Progress indicator dot
                Circle()
                    .fill(Color.white)
                    .frame(width: 16, height: 16)
                    .offset(y: -140)
                    .rotationEffect(.degrees(-90 + (timerManager.progress * 360)))
                    .shadow(color: .red.opacity(0.6), radius: 8, x: 0, y: 0)
                    .animation(.easeInOut(duration: 1.0), value: timerManager.progress)
            }
            
            // Center content
            VStack(spacing: 8) {
                Text(timerManager.displayTime)
                    .font(.system(size: 42, weight: .light, design: .monospaced))
                    .foregroundColor(.white)
                
                Text(timerManager.isRunning ? "LOCKED IN" : "READY TO LOCK IN")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(timerManager.isRunning ? .red : .gray)
                    .tracking(2)
                    .animation(.easeInOut, value: timerManager.isRunning)
                
                // Session time range
                if !timerManager.isRunning {
                    Text("21:14 → 06:18")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.05))
                        )
                        .padding(.top, 8)
                }
            }
        }
    }
}
