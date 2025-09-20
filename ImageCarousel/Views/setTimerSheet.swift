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
        ZStack{
            Rectangle()
                .fill(Color(red: 223/255, green: 223/255, blue: 223/255))
                .frame(width: 280, height: 40) // Set the width and height
                .cornerRadius(10) // Set the corner radius
                .offset(y:-12)
                .blendMode(.multiply)
            Text("Hours")
                .fontWeight(.semibold)
                .offset(x: -76, y: -12)
            Text("Min")
                .fontWeight(.semibold)
                .offset(x: 12, y: -12)
            Text("Sec")
                .fontWeight(.semibold)
                .offset(x: 112, y: -12)
            VStack(spacing: 0) { // Reduced spacing
                Text(isRunning ? "Modify Timer" : "Set Timer")
                    .font(.headline)
                
                HStack(spacing: 48) { // Less space between pickers
                    Picker("Hours", selection: $hours) {
                        ForEach(0..<24, id: \.self) { Text("\($0) ").frame(maxWidth: .infinity, alignment: .trailing) }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 50, height: 100)
                    
                    
              
                    Picker("Minutes", selection: $minutes) {
                        ForEach(0..<60, id: \.self) { Text("\($0)") }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 50, height: 100)
                    
                    
                    Picker("Seconds", selection: $seconds) {
                        ForEach(0..<60, id: \.self) { Text("\($0)") }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 50, height: 100)
                } .offset(x:-22)
                
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
}


#Preview {
    @State var hours = 0
    @State var minutes = 30
    @State var seconds = 00
    let isRunning = false

    return SetTimerSheet(
        hours: $hours,
        minutes: $minutes,
        seconds: $seconds,
        isRunning: isRunning,
        onStart: { print("Started") },
        onReset: { print("Reset") },
        onCancel: { print("Cancelled") },
        onStop: { print("Stopped") }
    )
}
