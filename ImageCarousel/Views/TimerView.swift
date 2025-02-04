import SwiftUI

struct TimerView: View {
    @StateObject private var timerManager = TimerManager()
    @State private var showSheet = false
    @State private var hours = 0
    @State private var minutes = 1
    @State private var seconds = 0
    
    var body: some View{
        timerButton
        
    }
    
    var timerButton: some View {
        
            VStack(spacing: 20) {
                Button(action: { showSheet = true }) {
                    Text(timerManager.isRunning ? formatTime(timerManager.timeRemaining) : "Set Timer")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Gradient(colors: [.white, .white.opacity(0.2)]))
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2 )
                }
            }
            .padding()
            .background(Color.clear)
            .sheet(isPresented: $showSheet) {
               
                SetTimerSheet(
                    hours: $hours,
                    minutes: $minutes,
                    seconds: $seconds,
                    isRunning: timerManager.isRunning,
                    onStart: {
                        let totalSeconds = (hours * 3600) + (minutes * 60) + seconds
                        timerManager.start(with: totalSeconds)
                        showSheet = false
                    },
                    onReset: {
                        let totalSeconds = (hours * 3600) + (minutes * 60) + seconds
                        timerManager.reset(to: totalSeconds)
                        showSheet = false
                    },
                    onCancel: {
                        showSheet = false
                    },
                    onStop: {
                        timerManager.stop()
                        showSheet = false
                    }
                ) .presentationDetents([.medium, .large])
            }
        }
    

    

    
    
    private func formatTime(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}


#Preview {
    TimerView()
}
