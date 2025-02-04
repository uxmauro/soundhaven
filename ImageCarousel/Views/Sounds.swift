//
//  Sounds.swift
//  ImageCarousel
//
//  Created by Mauro on 1/31/25.
//
import SwiftUI
import AVFoundation


class WhiteNoiseManager: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var playerNode = AVAudioPlayerNode()
    private var audioFile: AVAudioFile?
    private var buffer: AVAudioPCMBuffer?
    @Published var isPlaying = false
    @Published var volume: Float = 1.0 {
        didSet {
            playerNode.volume = volume
        }
    }
    
    init() {
        setupAudioSources()
    }



    func setupAudioSources() {
        guard let url = Bundle.main.url(forResource: "white-noise", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            audioFile = try AVAudioFile(forReading: url)
            let audioFormat = audioFile!.processingFormat
            
            // Create a buffer
            buffer = AVAudioPCMBuffer(pcmFormat: audioFormat,
                                    frameCapacity: AVAudioFrameCount(audioFile!.length))
            try audioFile!.read(into: buffer!)
            
            audioEngine.attach(playerNode)
            audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
            
            try audioEngine.start()
            
            // Schedule multiple buffers in advance
            scheduleBuffers()
            
        } catch {
            print("Error setting up audio: \(error.localizedDescription)")
        }
    }
    
    private func scheduleBuffers() {
        guard let buffer = buffer else { return }
        
        // Schedule multiple buffers to ensure smooth playback
        for _ in 0..<4 {
            playerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: { [weak self] in
                // Schedule another buffer when one completes
                DispatchQueue.main.async {
                    self?.scheduleBuffers()
                }
            })
        }
    }
    
    func togglePlayback() {
        if playerNode.isPlaying {
            playerNode.pause()
            isPlaying = false
        } else {
            if !isPlaying {
                scheduleBuffers() // Schedule new buffers when starting playback
            }
            playerNode.play()
            isPlaying = true
        }
    }
}


struct Sounds: View {
    @StateObject private var noiseManager = WhiteNoiseManager()
    
    var body: some View {
        VStack {
            Button(action: {
                noiseManager.togglePlayback()
            }) {
                Image(systemName: noiseManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 50))
            }
            .padding()
            
            HStack {
                Image(systemName: "speaker.fill")
                Slider(value: $noiseManager.volume, in: 0...1)
                Image(systemName: "speaker.wave.3.fill")
            }
            .padding()
        }
    }
}

#Preview {
    Sounds()
}
