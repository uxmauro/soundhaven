import SwiftUI

struct Main: View {
    @Environment(Store.self) private var store
    @State private var scrollID: Int?
    @State private var rotation: Double = 0
    @State private var rotatingImages: Set<Int> = [] // Track which images are rotating
    @State private var backgroundColor: Color = .gray // Default background color
    @State private var showColorPicker: Bool = false // Control color picker visibility
    
    @StateObject private var noiseManager = SoundManager()
    @State private var currentPlayingIndex: Int? // Track the currently playing index
    
    
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 10) {
                Text("SoundHaven")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .offset(y:80)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<store.sampleImages.count, id: \.self) { index in
                            let sampleImage = store.sampleImages[index]
                            let topLayerImage = store.topLayerImage[0]
                            VStack(alignment: .leading){
                                ZStack {
                                    Image(sampleImage.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .shadow(radius: 10)
                                        .padding(40)
                                        .rotationEffect(.degrees(rotatingImages.contains(index) ? rotation : 0))
                                    Image(topLayerImage.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding(48)
                                        .blendMode(.screen)
                                    //                                     Background circle
                                    Circle()
                                        .foregroundStyle(backgroundColor.gradient.shadow(.inner(color: .black.opacity(0.5), radius: 1, y: 2)))
                                        .frame(width: 70, height: 70)
                                    //
                                    
                                    // Play/Stop button overlay
                                    Button(action: {
                                        toggleRotation(for: index)
                                        handlePlayback(for: index)
                                        //                                        noiseManager.togglePlayback()
                                        
                                    }) {
                                        Image(systemName: rotatingImages.contains(index) ? "stop.circle.fill" : "play.circle.fill")
                                            .font(.system(size: 40))
                                            .foregroundStyle(.gray, .white.gradient)        .shadow(color: .black.opacity(0.2), radius: 2, y: 2)
                                        
                                        //                                            .foregroundStyle(rotatingImages.contains(index) ? Color.red : Color.green,  .white ) // Red for stop, Green for play
                                    }
                                }
                                
                            }
                            .containerRelativeFrame(.horizontal)
                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.6)
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.6)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $scrollID)
                .scrollTargetBehavior(.paging)
                .onReceive(timer) { _ in
                    if !rotatingImages.isEmpty {
                        withAnimation(.linear(duration: 0.1)) {
                            rotation += 6
                        }
                    }
                }
                VStack(spacing: 20) {
                    IndicatorView(imageCount: store.sampleImages.count, scrollID: $scrollID)
                    //                    .offset(y: -100)
                    
                    TimerView(soundManager: noiseManager) {
                        if let currentPlayingIndex, noiseManager.isPlaying {  // ✅ Only stop if sound is playing
                            toggleRotation(for: currentPlayingIndex)
                            handlePlayback(for: currentPlayingIndex)
                        }
                    }
                }
                .offset(y: -100)
            }
            .background(backgroundColor.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Full-width toolbar container
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    HStack {
                        Button(action: {
                            // Action if needed
                        }) {
                            Image(systemName: "slider.vertical.3")
                                .font(.subheadline)
                                .padding(10)
                                .background(backgroundColor)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
                        }
                        Spacer() // Pushes title to center
                    }
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Spacer() // Pushes title to center
                        ZStack {
                            // Invisible Color Picker Overlaid on Button
                            
                            
                            Image(systemName: "swatchpalette")
                                .font(.subheadline)
                                .padding(8)
                                .background(backgroundColor)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
                            
                            ColorPicker("", selection: $backgroundColor, supportsOpacity: false)
                                .opacity(1) // Make sure it is fully visible
                                .frame(width: 50, height: 50)
                                .offset(x: -8)
                                .blendMode(.destinationOver)
                            
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    
    
    
    
    
    private func toggleRotation(for index: Int) {
        if rotatingImages.contains(index) {
            rotatingImages.remove(index)
            if rotatingImages.isEmpty {
                let targetRotation = round(rotation / 360) * 360
                withAnimation(.linear(duration: 0.3)) {
                    rotation = targetRotation
                }
            }
        } else {
            rotatingImages.insert(index)
//            withAnimation(.linear(duration: 0.1)) { // Force UI refresh to catch missed frames
//                rotatingImages.insert(index)
//            }
        }
    }
    
    
    private func handlePlayback(for index: Int) {
        if currentPlayingIndex == index {
            // Stop the currently playing sound
            if noiseManager.isPlaying {  // ✅ Prevent stopping if nothing is playing
                noiseManager.stopPlayback()
            }
            rotatingImages.remove(index)
            currentPlayingIndex = nil
        } else {
            // Stop any currently playing sound before switching
            if let currentlyPlaying = currentPlayingIndex {
                if noiseManager.isPlaying {
                    noiseManager.stopPlayback()
                }
                rotatingImages.remove(currentlyPlaying)
            }
            
            // Ensure the sound starts AFTER stopping the previous one
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if index < SoundManager.NoiseType.allCases.count {
                    let noiseType = SoundManager.NoiseType.allCases[index]
                    noiseManager.switchNoise(to: noiseType)
                    noiseManager.togglePlayback()
                    rotatingImages.insert(index)
                    currentPlayingIndex = index
                }
            }
        }
    }
    
}



#Preview {
    Main()
        .environment(Store())
}

struct IndicatorView: View {
    let imageCount: Int
    @Binding var scrollID: Int?
    var body: some View {
        HStack {
            ForEach(0..<imageCount, id: \.self) { indicator in
            let index = scrollID ?? 0
                Button {
                    withAnimation {
                        scrollID = indicator
                    }
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                     .foregroundStyle(indicator == index ? Color.white : Color(.lightGray))
                }
            }
            
        }
        .padding(7)
    }
}
