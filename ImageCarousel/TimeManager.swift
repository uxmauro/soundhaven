import Foundation
import Combine

class TimerManager: ObservableObject {
    @Published var timeRemaining: Int = 0
    @Published var isRunning = false

    private var timer: Timer?
    private var soundManager: SoundManager
    

    init(soundManager: SoundManager) {
           self.soundManager = soundManager
       }
    

    func start(with time: Int) {
        timeRemaining = time
        isRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stop()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        timeRemaining = 0
        soundManager.stopPlayback()
    }

    func reset(to time: Int) {
        stop()
        start(with: time)
    }
}
