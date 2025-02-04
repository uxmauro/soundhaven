import SwiftUI

struct SetTimerSheet: View {
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int
    var isRunning: Bool

    var onStart: () -> Void
    var onReset: () -> Void
    var onCancel: () -> Void
    var onStop: () -> Void

    var body: some View {
        VStack(spacing: 12) { // Reduced spacing
            Text(isRunning ? "Modify Timer" : "Set Timer")
                .font(.headline)
                .padding(.top, 10) // Less top padding

            HStack(spacing: 15) { // Less space between pickers
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24, id: \.self) { Text("\($0) h") }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 75, height: 100) // Set a fixed height

                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60, id: \.self) { Text("\($0) m") }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 75, height: 100)

                Picker("Seconds", selection: $seconds) {
                    ForEach(0..<60, id: \.self) { Text("\($0) s") }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 75, height: 100)
            }
            .padding(.horizontal, 20) // Less horizontal padding

            HStack(spacing: 10) { // Less space between buttons
                Button("Cancel") { onCancel() }
                    .buttonStyle(.bordered)

                if isRunning {
                    Button("Reset") { onReset() }
                        .buttonStyle(.borderedProminent)

                    Button("Remove Timer") { onStop() }
                        .buttonStyle(.bordered)
                } else {
                    Button("Start") { onStart() }
                        .buttonStyle(.borderedProminent)
                }
            }
            .padding(.bottom, 10) // Less bottom padding
        }
        .frame(maxHeight: 250) // Limits overall height
    }
}
