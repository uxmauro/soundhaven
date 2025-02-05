

import AVFoundation

class SoundManager: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var players: [NoiseType: AVAudioPlayerNode] = [:] // ✅ Multiple players
    private var playerNode = AVAudioPlayerNode()
    private var audioFile: AVAudioFile?
    private var buffer: AVAudioPCMBuffer?
    @Published var isPlaying = false
    @Published var volume: Float = 0.5 {
        didSet {
            playerNode.volume = volume
        }
    }
    
    enum NoiseType: String, CaseIterable {  // Add CaseIterable here
           case white = "white-noise"
           case pink = "pink-noise"
           case brown = "brown-noise"
       }
    
    private var currentNoise: NoiseType?
    init() {
        setupAudioSources(noiseType: .white)
    }



    func setupAudioSources(noiseType: NoiseType) {
        guard let url = Bundle.main.url(forResource: noiseType.rawValue, withExtension: "mp3") else {
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
    
    func stopPlayback() {
        if playerNode.isPlaying {  // ✅ Prevent stopping an already stopped engine
            playerNode.stop()
            audioEngine.stop()
            audioEngine.reset()
            isPlaying = false
        }
    }

    
    
    func switchNoise(to newNoise: NoiseType) {
           if currentNoise == newNoise { return } // Prevent unnecessary reloading
           
           playerNode.stop()
           audioEngine.stop()
           audioEngine.detach(playerNode)
           
           playerNode = AVAudioPlayerNode() // Recreate player node
           setupAudioSources(noiseType: newNoise)
           
           currentNoise = newNoise
           if isPlaying {
               togglePlayback()
           }
       }
}
