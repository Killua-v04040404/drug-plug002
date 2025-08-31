//
//  musicmainview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//

import SwiftUI

struct MusicMainView: View {
    @EnvironmentObject var musicPlayer: MusicPlayerService
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Focus Beats")
                .font(.title.weight(.medium))
                .foregroundColor(.white)
            
            // Current Track Player
            ModernMusicPlayerView()
            
            // Music Categories
            VStack(alignment: .leading, spacing: 20) {
                Text("FOCUS PLAYLISTS")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.gray)
                    .tracking(1)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(musicPlayer.focusPlaylists) { track in
                        TrackCard(track: track)
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct ModernMusicPlayerView: View {
    @EnvironmentObject var musicPlayer: MusicPlayerService
    
    var body: some View {
        VStack(spacing: 20) {
            // Album Art
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.purple.opacity(0.6),
                            Color.blue.opacity(0.4),
                            Color.red.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)
                .overlay(
                    Image(systemName: "music.note")
                        .font(.title.weight(.light))
                        .foregroundColor(.white.opacity(0.8))
                )
                .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 10)
            
            // Track Info
            VStack(spacing: 4) {
                Text(musicPlayer.currentTrack?.title ?? "No track selected")
                    .font(.headline.weight(.medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(musicPlayer.currentTrack?.artist ?? "Select music to focus")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            // Controls
            HStack(spacing: 24) {
                Button(action: { musicPlayer.previousTrack() }) {
                    Image(systemName: "backward.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { musicPlayer.togglePlayPause() }) {
                    Image(systemName: musicPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.red, .orange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)
                                .shadow(color: .red.opacity(0.4), radius: 12, x: 0, y: 6)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(musicPlayer.isPlaying ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: musicPlayer.isPlaying)
                
                Button(action: { musicPlayer.nextTrack() }) {
                    Image(systemName: "forward.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.08),
                            Color.white.opacity(0.03)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        )
    }
}

struct TrackCard: View {
    let track: Track
    @EnvironmentObject var musicPlayer: MusicPlayerService
    
    var body: some View {
        Button(action: {
            musicPlayer.selectTrack(track)
        }) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "music.note")
                            .foregroundColor(.gray)
                            .font(.caption)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(track.title)
                        .foregroundColor(.white)
                        .font(.subheadline.weight(.medium))
                        .lineLimit(1)
                    Text(track.artist)
                        .foregroundColor(.gray)
                        .font(.caption)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: musicPlayer.currentTrack?.id == track.id ? "speaker.wave.2.fill" : "play.fill")
                    .foregroundColor(musicPlayer.currentTrack?.id == track.id ? .orange : .gray)
                    .font(.subheadline)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
