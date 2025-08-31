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
        VStack(spacing: 48) {
            // Focus Question Section
            VStack(spacing: 24) {
                Text("What's your focus?")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                    Text("General")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
                
                // Intention input
                TextField("What will you focus on?", text: .constant(""))
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    )
                    .foregroundColor(.primary)
                    .font(.subheadline)
            }
            
            // Circular Timer
            CircularTimerView()
            
            // Control Buttons
            HStack(spacing: 24) {
                Button(action: { showingTimerSettings = true }) {
                    Image(systemName: "timer")
                        .font(.title2.weight(.medium))
                        .foregroundColor(.secondary)
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: toggleTimer) {
                    Text(timerManager.isRunning ? "STOP SESSION" : "START SESSION")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
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
                                    radius: 16,
                                    x: 0,
                                    y: 8
                                )
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(timerManager.isRunning ? 0.98 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: timerManager.isRunning)
                
                Button(action: { timerManager.reset() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2.weight(.medium))
                        .foregroundColor(.secondary)
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(timerManager.isRunning)
                .opacity(timerManager.isRunning ? 0.5 : 1.0)
            }
            .padding(.horizontal, 32)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    @State private var pulseAnimation = false
    
    var body: some View {
        ZStack {
            // Outer glow effect
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.red.opacity(timerManager.isRunning ? 0.3 : 0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 140,
                        endRadius: 180
                    )
                )
                .frame(width: 360, height: 360)
                .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                .opacity(pulseAnimation ? 0.6 : 1.0)
                .animation(
                    timerManager.isRunning ?
                    .easeInOut(duration: 2.0).repeatForever(autoreverses: true) :
                    .easeInOut(duration: 0.3),
                    value: pulseAnimation
                )
                .onAppear {
                    if timerManager.isRunning {
                        pulseAnimation = true
                    }
                }
                .onChange(of: timerManager.isRunning) { isRunning in
                    pulseAnimation = isRunning
                }
            
            // Tick marks around the circle
            ZStack {
                ForEach(0..<60, id: \.self) { tick in
                    Rectangle()
                        .fill(Color.gray.opacity(tick % 5 == 0 ? 0.6 : 0.3))
                        .frame(
                            width: tick % 15 == 0 ? 4 : (tick % 5 == 0 ? 2 : 1),
                            height: tick % 15 == 0 ? 24 : (tick % 5 == 0 ? 16 : 8)
                        )
                        .offset(y: -160)
                        .rotationEffect(.degrees(Double(tick) * 6))
                }
            }
            
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.15), lineWidth: 12)
                .frame(width: 320, height: 320)
            
            // Progress circle with gradient
            Circle()
                .trim(from: 0, to: timerManager.progress)
                .stroke(
                    AngularGradient(
                        colors: [
                            Color.red,
                            Color.orange,
                            Color.red.opacity(0.8),
                            Color.red
                        ],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 320, height: 320)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: timerManager.progress)
                .shadow(color: .red.opacity(0.4), radius: 8, x: 0, y: 0)
            
            // Progress indicator dot
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.white, Color.red.opacity(0.8)],
                        center: .center,
                        startRadius: 2,
                        endRadius: 8
                    )
                )
                .frame(width: 20, height: 20)
                .offset(y: -160)
                .rotationEffect(.degrees(-90 + (timerManager.progress * 360)))
                .shadow(color: .red.opacity(0.8), radius: 12, x: 0, y: 0)
                .animation(.easeInOut(duration: 1.0), value: timerManager.progress)
            
            // Center content
            VStack(spacing: 12) {
                Text(timerManager.displayTime)
                    .font(.system(size: 48, weight: .thin, design: .monospaced))
                    .foregroundColor(.primary)
                
                Text(timerManager.isRunning ? "LOCKED IN" : "READY TO LOCK IN")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(timerManager.isRunning ? .red : .gray)
                    .tracking(2)
                    .animation(.easeInOut, value: timerManager.isRunning)
                
                // Session time range
                if !timerManager.isRunning {
                    Text("21:14 → 09:46")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.gray.opacity(0.1))
                        )
                        .padding(.top, 8)
                }
            }
        }
        .frame(width: 400, height: 400)
    }
}
