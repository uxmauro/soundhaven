//import SwiftUI
//
//struct Main: View {
//    @Environment(Store.self) private var store
//    @State private var scrollID: Int?
//    @State private var rotation: Double = 0
//    @State private var rotatingImages: Set<Int> = [] // Track which images are rotating
//    @State private var backgroundColor: Color = .gray // Default background color
//    
//    @StateObject private var noiseManager = SoundManager()
//    @State private var currentPlayingIndex: Int? // Track the currently playing index
//    
//    
//    
//    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
//    
//    var body: some View {
//        NavigationStack {
//            
//            VStack(spacing: 10) {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    LazyHStack(spacing: 0) {
//                        ForEach(0..<store.sampleImages.count, id: \.self) { index in
//                            let sampleImage = store.sampleImages[index]
//                            let topLayerImage = store.topLayerImage[0]
//                            VStack(alignment: .leading){
//                                ZStack {
//                                    Image(sampleImage.imageName)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(maxWidth: .infinity)
//                                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                                        .shadow(radius: 10)
//                                        .padding(40)
//                                        .rotationEffect(.degrees(rotatingImages.contains(index) ? rotation : 0))
//                                    Image(topLayerImage.imageName)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(maxWidth: .infinity)
//                                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                                        .padding(48)
//                                        .blendMode(.screen)
//                                    //                                     Background circle
//                                    Circle()
//                                        .foregroundStyle(backgroundColor.gradient.shadow(.inner(color: .black.opacity(0.5), radius: 1, y: 2)))
//                                        .frame(width: 70, height: 70)
//                                    //
//                                    
//                                    // Play/Stop button overlay
//                                    Button(action: {
//                                        toggleRotation(for: index)
//                                        handlePlayback(for: index)
//                                        //                                        noiseManager.togglePlayback()
//                                        
//                                    }) {
//                                        Image(systemName: rotatingImages.contains(index) ? "stop.circle.fill" : "play.circle.fill")
//                                            .font(.system(size: 40))
//                                            .foregroundStyle(.gray, .white.gradient)        .shadow(color: .black.opacity(0.2), radius: 2, y: 2)
//                                        
//                                    }
//                                }
//                                
//                            }
//                            .containerRelativeFrame(.horizontal)
//                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
//                                content
//                                    .opacity(phase.isIdentity ? 1.0 : 0.6)
//                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.6)
//                            }
//                        }
//                    }
//                    .scrollTargetLayout()
//                }
//                .scrollPosition(id: $scrollID)
//                .scrollTargetBehavior(.paging)
//                .onReceive(timer) { _ in
//                    if !rotatingImages.isEmpty {
//                        withAnimation(.linear(duration: 0.1)) {
//                            rotation += 6
//                        }
//                    }
//                }
//                VStack(spacing: 20) {
//                    IndicatorView(imageCount: store.sampleImages.count, scrollID: $scrollID)
//                    //                    .offset(y: -100)
//                 
//                    TimerView(soundManager: noiseManager) {
//                        if let currentPlayingIndex {
//                            toggleRotation(for: currentPlayingIndex)
//                            handlePlayback(for: currentPlayingIndex)
//                        }
//                    }
//                    .opacity(noiseManager.isPlaying ? 1 : 0)  // Hide when no sound is playing
//                    .allowsHitTesting(noiseManager.isPlaying) // Disable interactions when hidden
//
//                }
//                .offset(y: -100)
//            }
//            .background(backgroundColor.ignoresSafeArea())
//            .navigationBarTitleDisplayMode(.inline)
////           
//            
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    NavigationLink(destination: AudioMixer()) {
//                        Image(systemName: "line.3.horizontal")
//                            .font(.subheadline)
//                            .padding(10)
//                            .background(backgroundColor)
//                            .clipShape(Circle())
//                            .foregroundColor(.white)
//                            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
//                    }
//                }
//                
//                ToolbarItem(placement: .principal) { // Use `.principal` placement for centering
//                    Text("SoundHaven")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(.primary)
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(destination: AudioMixer()) {
//                        Image(systemName: "slider.vertical.3")
//                            .font(.subheadline)
//                            .padding(10)
//                            .background(backgroundColor)
//                            .clipShape(Circle())
//                            .foregroundColor(.white)
//                            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
//                    }
//                }
//            }
//
//
//            
//        }
//    }
//    
//    
//    
//    
//    
//    
//    private func toggleRotation(for index: Int) {
//        if rotatingImages.contains(index) {
//            rotatingImages.remove(index)
//        } else {
//            rotatingImages.insert(index)
//        }
//    }
//
//    
//    
//    private func handlePlayback(for index: Int) {
//        print("🔄 Toggling playback for index: \(index)")
//        
//        if currentPlayingIndex == index {
//            // If already playing, stop it
//            print("🛑 Stopping playback for index: \(index)")
//            noiseManager.stopPlayback()
//            rotatingImages.remove(index)
//            currentPlayingIndex = nil
//        } else {
//            // Stop any currently playing sound first
//            if let currentlyPlaying = currentPlayingIndex {
//                print("🛑 Stopping currently playing index: \(currentlyPlaying)")
//                noiseManager.stopPlayback()
//                rotatingImages.remove(currentlyPlaying)
//            }
//
//            // Play the new sound only if the index is valid
//            if index < SoundManager.NoiseType.allCases.count {
//                let noiseType = SoundManager.NoiseType.allCases[index]
//                print("🎵 Switching noise to: \(noiseType)")
//
//                // Ensure the noise manager actually starts playing
//                noiseManager.switchNoise(to: noiseType)
//                
//                if !noiseManager.isPlaying {
//                    print("▶️ Explicitly starting playback")
//                    noiseManager.togglePlayback() // Explicitly start playback
//                }
//                
//                rotatingImages.insert(index)
//                currentPlayingIndex = index
//            }
//        }
//
//        // Print the state after handling playback
//        print("✅ Current Playing Index: \(String(describing: currentPlayingIndex))")
//        print("🔊 Noise Manager isPlaying: \(noiseManager.isPlaying)")
//    }
//
//
//
//    
//}
//
//
//
//#Preview {
//    Main()
//        .environment(Store())
//}
//
//struct IndicatorView: View {
//    let imageCount: Int
//    @Binding var scrollID: Int?
//    var body: some View {
//        HStack {
//            ForEach(0..<imageCount, id: \.self) { indicator in
//            let index = scrollID ?? 0
//                Button {
//                    withAnimation {
//                        scrollID = indicator
//                    }
//                } label: {
//                    Image(systemName: "circle.fill")
//                        .font(.system(size: 8))
//                     .foregroundStyle(indicator == index ? Color.white : Color(.lightGray))
//                }
//            }
//            
//        }
//        .padding(7)
//    }
//}





/// TEST MAIN
///
///
///
/// import SwiftUI
//
//struct TestMain: View {
//    @Environment(Store.self) private var store
//    @State private var scrollID: Int?
//    @State private var rotation: Double = 0
//    @State private var rotatingImages: Set<Int> = [] // Track which images are rotating
//
//    
//    let backgroundColor: Color = Color(red: 33/255, green: 33/255, blue: 33/255) //
//    @StateObject private var noiseManager = AudioManager.shared
//    @State private var currentPlayingIndex: Int? // Track the currently playing index
//    
//    
//    
//    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
//    
//    
//    let sliderAnimation: Animation = .easeInOut(duration: 0.5).delay(0.5)
//
//    
//    var body: some View {
//        NavigationStack {
//            
//            VStack(spacing: 10) {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    LazyHStack(spacing: 0) {
//                        ForEach(0..<store.sampleImages.count, id: \.self) { index in
//                            let sampleImage = store.sampleImages[index]
//                            let topLayerImage = store.topLayerImage[0]
//                            VStack(alignment: .leading){
//                                ZStack {
//                                    Image(sampleImage.imageName)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(maxWidth: .infinity)
//                                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                                        .shadow(radius: 10)
//                                        .padding(40)
//                                        .rotationEffect(.degrees(noiseManager.isPlaying[noiseManager.sounds[index].file] == true ? rotation : 0))
//
//                                    Image(topLayerImage.imageName)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(maxWidth: .infinity)
//                                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                                        .padding(48)
//                                        .blendMode(.screen)
//                                    //                                     Background circle
//                                    Circle()
//                                        .foregroundStyle(backgroundColor.gradient.shadow(.inner(color: .black.opacity(0.5), radius: 1, y: 2)))
//                                        .frame(width: 70, height: 70)
//                                    //
//                                    
//                                    // Play/Stop button overlay
////                                    Button(action: {
////                                        toggleRotation(for: index)
////                                        let soundFile = noiseManager.sounds[index].file // Retrieve the string using the index
////                                            noiseManager.playPauseAudio(name: soundFile)
////                                        //                                        noiseManager.togglePlayback()
////
////                                    }) {
////                                        Image(systemName: rotatingImages.contains(index) ? "stop.circle.fill" : "play.circle.fill")
////                                            .font(.system(size: 40))
////                                            .foregroundStyle(.gray, .white.gradient)        .shadow(color: .black.opacity(0.2), radius: 2, y: 2)
////
////                                    }
//                                    
//                                    Button(action: {
//                                        let soundFile = noiseManager.sounds[index].file
//                                        noiseManager.playPauseAudio(name: soundFile)
//                                    }) {
//                                        Image(systemName: noiseManager.isPlaying[noiseManager.sounds[index].file] == true ? "stop.circle.fill" : "play.circle.fill")
//                                            .font(.system(size: 40))
//                                            .foregroundStyle(.gray, .white.gradient)
//                                            .shadow(color: .black.opacity(0.2), radius: 2, y: 2)
//                                    }
//
//
//                                    
//                                }
//                                HStack {
//                                    Image(systemName: "speaker.wave.1")
//                                        .padding(10)
//                                        .foregroundColor(.white)
//
//                                    Slider(
//                                        value: Binding(
//                                            get: { noiseManager.players[noiseManager.sounds[index].file]?.volume ?? 0.5 },
//                                            set: { noiseManager.setVolume(name: noiseManager.sounds[index].file, volume: $0) }
//                                        ),
//                                        in: 0...1
//                                    )
//                                    .cornerRadius(10)
//
//                                    Image(systemName: "speaker.wave.3")
//                                        .padding(10)
//                                        .foregroundColor(.white)
//                                }
//                                .offset(y: -20)
//                                .padding(.horizontal, 60)
//                                .opacity(noiseManager.isPlaying[noiseManager.sounds[index].file] == true ? 1.0 : 0.0)
//                                .animation(sliderAnimation, value: noiseManager.isPlaying[noiseManager.sounds[index].file] == true)
//                                
//                            }
//                            .containerRelativeFrame(.horizontal)
//                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
//                                content
//                                    .opacity(phase.isIdentity ? 1.0 : 0.6)
//                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.6)
//                            }
//                        }
//                    }
//                    .scrollTargetLayout()
//                }
//                .scrollPosition(id: $scrollID)
//                .scrollTargetBehavior(.paging)
//                .onReceive(timer) { _ in
//                    if noiseManager.isPlaying.values.contains(true) { // Only rotate if any sound is playing
//                        withAnimation(.linear(duration: 0.1)) {
//                            rotation += 6
//                        }
//                    }
//                }
//                VStack(spacing: 20) {
//                    IndicatorView(imageCount: store.sampleImages.count, scrollID: $scrollID)
//                                        .offset(y: -20)
//                 
////                    TimerView(soundManager: noiseManager) {
////                        if let currentPlayingIndex {
////                            toggleRotation(for: currentPlayingIndex)
////                            handlePlayback(for: currentPlayingIndex)
////                        }
////                    }
////                    .opacity(noiseManager.isPlaying ? 1 : 0)  // Hide when no sound is playing
////                    .allowsHitTesting(noiseManager.isPlaying) // Disable interactions when hidden
//                    
//                }
//                .offset(y: -100)
//            }
//            .background(backgroundColor.ignoresSafeArea())
//            .navigationBarTitleDisplayMode(.inline)
//
//            
//            
//            .toolbar {
//                
//                ToolbarItem(placement: .navigationBarLeading) {
//                    
//                        NavigationLink(destination: AudioMixer()) {
//                            Image(systemName: "line.3.horizontal")
//                                .font(.subheadline)
//                                .padding(12)
//                                .background(backgroundColor)
//                                .clipShape(Circle())
//                                .foregroundColor(.white)
//                                .shadow(color: .white.opacity(0.9), radius: 0, x: 1, y: 1)
//                                .shadow(color: .white.opacity(0.9), radius: 0, x: -1, y: -1)
//                                .shadow(color: .white.opacity(0.9), radius: 0, x: -1, y: 1)
//                                .shadow(color: .white.opacity(0.9), radius: 0, x: 1, y: -1)
//                        }
//                    }
//                
//                
//                ToolbarItem(placement: .principal) {
//                    
//                        Text("SoundHaven")
//                        .font(.headline)
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                            .foregroundColor(.primary)
//                    
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    
//                        NavigationLink(destination: MixerView()) {
//                            Image(systemName: "slider.vertical.3")
//                                .font(.subheadline)
//                                .padding(12)
//                                 
//                                .clipShape(Circle())
//                                .foregroundColor(.white)
//                                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
//                        
//                    }
//                }
//            }
//
//
//            
//        }
//    }
//    
//    
//    
//    
//    
//    private func toggleRotation(for index: Int) {
//        if rotatingImages.contains(index) {
//            rotatingImages.remove(index)
//        } else {
//            rotatingImages.insert(index)
//        }
//    }
//
//
//    
//}
//
//
//
//#Preview {
//    TestMain()
//        .environment(Store())
//}
//
//
//
//struct IndicatorView: View {
//    let imageCount: Int
//    @Binding var scrollID: Int?
//    
//    private let maxVisibleDots = 6 // Maximum number of dots displayed at once
//    
//    var body: some View {
//        HStack(spacing: 4) {
//            ForEach(visibleIndicators(), id: \.self) { indicator in
//                let index = scrollID ?? 0
//                let scale = dotScale(for: indicator)
//                let opacity = dotOpacity(for: indicator)
//                
//                Button {
//                    withAnimation {
//                        scrollID = indicator
//                    }
//                } label: {
//                    Circle()
//                        .frame(width: 8, height: 8)
//                        .scaleEffect(scale)
//                        .foregroundStyle(indicator == index ? Color.white : Color(.lightGray))
//                        .opacity(opacity)
//                }
//            }
//        }
//        .padding(4)
//    }
//    
//    // Determines which indicators are visible
//    private func visibleIndicators() -> [Int] {
//        let index = scrollID ?? 0
//        
//        if imageCount <= maxVisibleDots {
//            return Array(0..<imageCount)
//        }
//        
//        let halfMax = maxVisibleDots / 2
//        
//        if index <= halfMax {
//            return Array(0..<maxVisibleDots)
//        } else if index >= imageCount - halfMax {
//            return Array((imageCount - maxVisibleDots)..<imageCount)
//        } else {
//            return Array((index - halfMax)...(index + halfMax))
//        }
//    }
//    
//    // Scales down dots at the edges to create the Instagram-like effect
//    private func dotScale(for indicator: Int) -> CGFloat {
//        let index = scrollID ?? 0
//        let distance = abs(index - indicator)
//        
//        if distance == 3 { return 0.8 }
//        if distance == 4 { return 0.6 }
//        if distance >= 5 { return 0.4 }
//        
//        return 1.0
//    }
//    
//    // Fades out dots at the edges
//    private func dotOpacity(for indicator: Int) -> Double {
//        let index = scrollID ?? 0
//        let distance = abs(index - indicator)
//        
//        if distance == 3 { return 0.7 }
//        if distance == 4 { return 0.5 }
//        if distance >= 5 { return 0.3 }
//        
//        return 1.0
//    }
//}
//
