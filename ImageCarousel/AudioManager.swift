import AVFoundation
// new code
import MediaPlayer


struct Sound: Codable, Identifiable {
    var id: String { file }
    let name: String
    let file: String
}

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    @Published var sounds: [Sound] = []
    @Published var players: [String: AVAudioPlayer] = [:]
    @Published var isPlaying: [String: Bool] = [:]

    private init() {
        setupAudioSession()
        loadSounds()
        setupNotifications()  // Add notification observers
        setupRemoteTransportControls()
    }
    //new code
    private func setupRemoteTransportControls() {
           let commandCenter = MPRemoteCommandCenter.shared()
           
           commandCenter.playCommand.addTarget { [weak self] event in
               if let currentSound = self?.sounds.first(where: { self?.isPlaying[$0.file] == false }) {
                   self?.playPauseAudio(name: currentSound.file)
                   return .success
               }
               return .commandFailed
           }
           
           commandCenter.pauseCommand.addTarget { [weak self] event in
               if let currentSound = self?.sounds.first(where: { self?.isPlaying[$0.file] == true }) {
                   self?.playPauseAudio(name: currentSound.file)
                   return .success
               }
               return .commandFailed
           }
           
           updateNowPlayingInfo(isPlaying: false)
       }
       
       private func updateNowPlayingInfo(isPlaying: Bool) {
           var nowPlayingInfo = [String: Any]()
           nowPlayingInfo[MPMediaItemPropertyTitle] = "SoundHaven"
           nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
           nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
           
           MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
       }
       
  
    
    
    //end new code
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
            
            // Enable background audio
            try session.setActive(true, options: [])
        } catch {
            print("❌ Error setting up audio session: \(error)")
        }
    }
    
    // Add notification handling for interruptions
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
    }
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            // Audio session interrupted (e.g., phone call)
            for (name, player) in players {
                if player.isPlaying {
                    player.pause()
                    isPlaying[name] = false
                }
            }
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // Resume playing audio
                for (name, player) in players {
                    if isPlaying[name] == true {
                        player.play()
                    }
                }
            }
        @unknown default:
            break
        }
        objectWillChange.send()
    }
    
    @objc private func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        
        // Handle route changes (e.g., headphones removed)
        switch reason {
        case .oldDeviceUnavailable:
            for (name, player) in players {
                if player.isPlaying {
                    player.pause()
                    isPlaying[name] = false
                }
            }
        default:
            break
        }
        objectWillChange.send()
    }

    func loadSounds() {
        if let url = Bundle.main.url(forResource: "sounds", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                sounds = try JSONDecoder().decode([Sound].self, from: data)
                for sound in sounds {
                    loadAudio(name: sound.file)
                }
            } catch {
                print("❌ Error decoding JSON: \(error)")
            }
        }
    }

    func loadAudio(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            print("❌ File not found: \(name)")
            return
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            players[name] = player
            isPlaying[name] = false
        } catch {
            print("❌ Error loading audio: \(error)")
        }
    }

//    func playPauseAudio(name: String) {
//        guard let player = players[name] else { return }
//        if player.isPlaying {
//            player.pause()
//            isPlaying[name] = false
//        } else {
//            player.play()
//            isPlaying[name] = true
//        }
//        objectWillChange.send()
//    }
    
    
    func playPauseAudio(name: String) {
        guard let player = players[name] else { return }
        if player.isPlaying {
            player.pause()
            isPlaying[name] = false
            updateNowPlayingInfo(isPlaying: false)
        } else {
            player.play()
            isPlaying[name] = true
            updateNowPlayingInfo(isPlaying: true)
        }
        objectWillChange.send()
    }

    func setVolume(name: String, volume: Float) {
        players[name]?.volume = volume
    }
}
